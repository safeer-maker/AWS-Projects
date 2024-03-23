# Lambda function to compress images uploaded to S3 bucket

resource "aws_lambda_function" "image_compression_lambda" {
    function_name = "image_compression_lambda"
    role = aws_iam_role.lambda_role.arn
    runtime = "python3.9"
    architectures = ["x86_64"]
    filename = "~/Downloads/my-deployment-package.zip"
    handler = "lambda_function.lambda_handler"

    environment {
        variables = {
            processed_bucket = aws_s3_bucket.processed_bucket.bucket
        }
    }

    timeout = 60
    memory_size = 128

}
