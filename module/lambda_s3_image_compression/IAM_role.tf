# IAm Role for s3 access to lambda

data "aws_caller_identity" "current" {}

# createing IAM policy to attach to lambda role
resource "aws_iam_policy" "s3_access_lambda" {
    name = "s3_access_lambda"
    description = "Allow lambda to access s3"

	policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": 
	[
	  {
		"Effect":"Allow",
		"Action":[
		   "s3:*"
		],
		"Resource":[
			"arn:aws:s3:::${aws_s3_bucket.source_bucket.id}",
			"arn:aws:s3:::${aws_s3_bucket.source_bucket.id}/*",
			"arn:aws:s3:::${aws_s3_bucket.processed_bucket.id}/*",
			"arn:aws:s3:::${aws_s3_bucket.processed_bucket.id}"
		]
		
	  },
	  {
		  "Effect": "Allow",
		  "Action": "logs:CreateLogGroup",
		  "Resource": "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*"
	  },
	  {
		  "Effect": "Allow",
		  "Action": [
			  "logs:CreateLogStream",
			  "logs:PutLogEvents"
		  ],
		  "Resource": [
			  "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/pixelator:*"
		  ]
	  }
	]
}
EOF
}

# creating aws IAM role for lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [aws_iam_policy.s3_access_lambda.arn]
}
