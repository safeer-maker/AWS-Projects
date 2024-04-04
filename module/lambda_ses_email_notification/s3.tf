locals {
    serverless_file = "serverless.js"
    bucket_name = "web_bucket"
}

# data "backed" "envars" {
#     file = templatefile("${path.module}/assets/${local.serverless_file}" , { API_GATEWAY_ARN = aws_api_gateway_rest_api.lambda_api.arn })
# }

resource "aws_s3_bucket" "web_bucket" {
    bucket = var.web_bucket_name


    force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.web_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.web_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.web_bucket.arn,
      "${aws_s3_bucket.web_bucket.arn}/*",
    ]
  }
}
