# IAm Role for s3 access to lambda

data "aws_caller_identity" "current" {}

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
    # inline_policy = {
	# 	policy = file ("IAM_policy_s3.json")
	# }
}
