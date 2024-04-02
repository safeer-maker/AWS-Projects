locals {
  lambda_ses_file_name = "lambda_ses"
  lambda_api_file_name = "lambda_api"
}

resource "aws_lambda_function" "lambda_ses" {

  filename      = "${path.module}/assets/${local.lambda_ses_file_name}.zip"
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
  depends_on = [ terraform_data.zipfile ]
}

resource terraform_data "zipfile" {
  provisioner "local-exec" {
    command = "zip -r ${path.module}/assets/${local.lambda_ses_file_name}.zip ${path.module}/assets/${local.lambda_ses_file_name}.py" 
  }
}

resource terraform_data "zipfile_api" {
  provisioner "local-exec" {
    command =  "zip -r ${path.module}/assets/${local.lambda_api_file_name}.zip ${path.module}/assets/${local.lambda_api_file_name}.py"
            
  }
}

resource "aws_lambda_function" "lambda_api" {
  filename      = "${path.module}/assets/${local.lambda_api_file_name}.zip"
  function_name = "lambda_api"
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
  depends_on = [ terraform_data.zipfile_api ]
}

