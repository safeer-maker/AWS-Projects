# Creation required s3 buckets to store images
# source s3 bucket for image storage
resource "aws_s3_bucket" "source_bucket" {
    bucket = var.source_bucket_name
}

# processed s3 bucket after image compression
resource "aws_s3_bucket" "processed_bucket" {
    bucket = var.processed_bucket_name
}

# Bucket Notification for Lambda trigger
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.source_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_compression_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}