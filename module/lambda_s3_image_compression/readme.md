# Lambda and S3 for Image compression

The project compress images using s3 and lambda. This project contains multiple blocks to complete it

- Two S3 buckets
- Lambda Function
- IAM Role
- Lambda Trigger

## Table of Content

Table of content for Lambda and S3 for Image compression
- [S3 buckets](#s3-buckets)
- [IAM Role](#iam-role)
- [Lambda Function](#lambda-function)
- [Results](#results)

## S3 buckets

Two s3 buckets are require. **First bucket** is *source* bucket to upload the images. these images are then porcessed by lambda function. Then **Second bucket** is *processed* bucket, which is used to store compressed images.

> To add **lambda trigger** it is necessory to add `aws_s3_bucket_notification` resource in S3.

## IAM Role

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

## Lambda Function

Lambda function is a serverless way to perform compute task on AWS. In this particular case I have used lambda for python 3.8 and uploaded .zip file from local machine. 

> there are multiple parameters that needed to configure to run lambda properly. like `timeout`, `memory_size` and `architectures`. 

[To add Lambda Trigger follow this link.](https://www.pulumi.com/ai/answers/8urwKhaMGKSDyPHaRy49AS/configuring-lambda-s3-event-triggers-in-terraform) Adding trigger was difficult part for me.

## Results

The sample input of an image is 

![](/module/lambda_s3_image_compression/assets/cupcake.jpg)

The results for 8x8

![](/module/lambda_s3_image_compression/assets/pixelated-8x8-cupcake.jpg)

The results for 64x64

![](/module/lambda_s3_image_compression/assets/pixelated-64x64-cupcake.jpg)

