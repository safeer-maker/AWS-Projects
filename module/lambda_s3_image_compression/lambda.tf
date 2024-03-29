# Lambda function to compress images uploaded to S3 bucket

resource "aws_lambda_function" "image_compression_lambda" {
    function_name = "image_compression_lambda"
    role = aws_iam_role.lambda_role.arn
    runtime = "python3.9"
    architectures = ["x86_64"]
    filename = "${path.module}/assets/my-deployment-package.zip"
    handler = "lambda_function.lambda_handler"

    environment {
        variables = {
            processed_bucket = aws_s3_bucket.processed_bucket.bucket
        }
    }

    timeout = 60
    memory_size = 128

}

# Lets create a trigger for the lambda function.check
# The trigger is an s3 bucket object created event.
# the event use source s3 bucket as the trigger.
resource "aws_lambda_permission" "s3_trigger" {
    statement_id = "AllowExecutionFromS3Bucket"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.image_compression_lambda.function_name
    principal = "s3.amazonaws.com"
    source_arn = aws_s3_bucket.source_bucket.arn
}
