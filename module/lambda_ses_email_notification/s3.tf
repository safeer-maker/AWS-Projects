locals {
    serverless_file = "serverless.js"
    web_bucket_name = "web-bucket-143"
}

# data "backed" "envars" {
#     file = templatefile("${path.module}/assets/${local.serverless_file}" , { API_GATEWAY_ARN = aws_api_gateway_rest_api.lambda_api.arn })
# }

resource "aws_s3_bucket" "web_bucket" {
    bucket = local.web_bucket_name

    force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.web_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.web_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "b" {
   bucket = aws_s3_bucket.web_bucket.id
   policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicRead",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["${aws_s3_bucket.web_bucket.arn}/*"]
    }
  ]
}
POLICY

}
