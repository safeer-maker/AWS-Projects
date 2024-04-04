output "lambda_arn" {
  value = aws_lambda_function.lambda_ses.arn
}

output "lambda_api_gateway_arn" {
  value = aws_lambda_function.lambda_api.arn
}
