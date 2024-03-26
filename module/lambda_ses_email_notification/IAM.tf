# IAM policies 

resource "aws_iam_policy" "lambda_ses_policy" {
    name = "lambda_ses_policy"
    description = "Allow lambda to send email using SES"
    policy = file("${path.module}/policy_json/lambda_ses_policy.json")
}

resource "aws_iam_role" "lambda_ses_role" {
    name = "lambda_ses_role"
    assume_role_policy = file("${path.module}/policy_json/lambda_assume_role_policy.json")
    managed_policy_arns = [aws_iam_policy.lambda_ses_policy.arn]
}