# Lambda and S3 for Image compression

The project compress images using s3 and lambda. This project contains multiple blocks to complete it

- Two S3 buckets
- Lambda Function
- IAM Role

## S3 buckets

Two s3 buckets are require. **First bucket** is *source* bucket to upload the images. these images are then porcessed by lambda function. Then **Second bucket** is *processed* bucket, which is used to store compressed images.

# IAM Role

Lambda function can read and write for s3 bucket using IAM Role. 

To create IAM role, an IAM policy needed to be created first and then attached to IAM role. I have granded read and right access to only s3 bucket created for this porject. Moreover cloudwatch logs poily is also attached for better visibility.


```JSON
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
			"arn:aws:s3:::REPLACEME-processed",
			"arn:aws:s3:::REPLACEME-processed/*",
			"arn:aws:s3:::REPLACEME-source/*",
			"arn:aws:s3:::REPLACEME-source"
		]
		
	  },
	  {
		  "Effect": "Allow",
		  "Action": "logs:CreateLogGroup",
		  "Resource": "arn:aws:logs:us-east-1:YOURACCOUNTID:*"
	  },
	  {
		  "Effect": "Allow",
		  "Action": [
			  "logs:CreateLogStream",
			  "logs:PutLogEvents"
		  ],
		  "Resource": [
			  "arn:aws:logs:us-east-1:YOURACCOUNTID:log-group:/aws/lambda/pixelator:*"
		  ]
	  }
	]
}
```
