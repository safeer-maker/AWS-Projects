resource "aws_lambda_function" "lambda_ses" {

  filename      = "${path.module}/assets/lambda_ses.zip"
  function_name = "lambda_ses_sms"
  role          = aws_iam_role.lambda_ses_role.arn
  handler       = "index.test"
  architectures = ["x86_64"]

  timeout = "60"
  memory_size = 128
  runtime = "python3.12"

  environment {
    variables = {
      FROM_EMAIL_ADDRESS = var.email_primary
    }
  }
}
