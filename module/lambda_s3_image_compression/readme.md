# Lambda and S3 for Image compression

The project compress images using s3 and lambda. This project contains multiple blocks to complete it

- Two S3 buckets
- Lambda Function
- IAM Role

## S3 buckets

Two s3 buckets are require. **First bucket** is *source* bucket to upload the images. these images are then porcessed by lambda function. Then **Second bucket** is *processed* bucket, which is used to store compressed images.

