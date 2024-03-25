# AWS-Projects
This repo contain multiple porjects on AWS. The IAC is written in terraform. 

## [Lambda and S3 for Image Compression](/module/lambda_s3_image_compression/readme.md)

For this project I have used two s3 buckets and a lambda fucnction.
- **Source S3 bucket** is used to upload images for compression.
- **Lambda function** having **IAM role** to access the buckets, triggers with source bucket.
- After compression is done the source iamges are stored in **Processed s3 bucket**.




