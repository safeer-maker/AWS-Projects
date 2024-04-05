locals {
    serverless_file = "serverless.js"
    web_bucket_name = "web-bucket-143"
    file_name = "serverless.js"
}

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

resource "aws_s3_object" "web_files" {
  for_each = fileset("${path.module}/assets/serverless_frontend", "*.*")

  bucket = aws_s3_bucket.web_bucket.id
  key = each.key
  source = "${path.module}/assets/serverless_frontend/${each.key}"
  etag = filemd5("${path.module}/assets/serverless_frontend/${each.key}")  
}

resource "template_file" "add_arn" {
  template = file ("${path.module}/assets/serverless_frontend/${local.serverless_file}")

  vars = { API_GATEWAY_ARN = aws_api_gateway_rest_api.lambda_api.arn }
  depends_on = [ aws_s3_object.web_files ]
}

resource "local_file" "temp_data_file" {
  filename = "${path.module}/temp_data.txt"
  content  = template_file.add_arn.rendered

  depends_on = [ template_file.add_arn ]
}

resource "aws_s3_object" "file_mod" {
  bucket = aws_s3_bucket.web_bucket.id
  key = local.serverless_file
  source = local_file.temp_data_file.filename
  etag = filemd5("${path.module}/assets/serverless_frontend/${local.serverless_file}")

  depends_on = [ template_file.add_arn]
}

