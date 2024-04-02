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
    # command = "zip -r ${path.module}/assets/${local.lambda_ses_file_name}.zip ${path.module}/assets/${local.lambda_ses_file_name}.py" 
    command = "cd ${path.module}/assets/ && zip ${local.lambda_ses_file_name}.zip ${local.lambda_ses_file_name}.py"
  }
}

resource terraform_data "zipfile_api" {
  provisioner "local-exec" {
    command = "cd ${path.module}/assets/ && zip ${local.lambda_api_file_name}.zip ${local.lambda_api_file_name}.py"
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
      STATEMACHINE_ARN = aws_sfn_state_machine.sfn_state_machine.arn
    }
  }

  depends_on = [ terraform_data.zipfile_api ]
}

resource "terraform_data" "delete_zipfile" {
  provisioner "local-exec" {
    command = "rm ${path.module}/assets/${local.lambda_ses_file_name}.zip"
  }
  depends_on = [ aws_lambda_function.lambda_ses ]
}

resource "terraform_data" "delete_zipfile_api" {
  provisioner "local-exec" {
    command = "rm ${path.module}/assets/${local.lambda_api_file_name}.zip"
  }
  depends_on = [ aws_lambda_function.lambda_api ]
}
