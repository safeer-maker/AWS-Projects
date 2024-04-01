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

# Attach SES policy to the role

resource "aws_iam_policy" "state_machine_policy" {
    name = "sm_policy"
    description = "Allow State Machine to create cloud watch logs and invoke lambda function"
    policy = file("${path.module}/policy_json/state_machine_policy.json")
}

resource "aws_iam_role" "state_machine_role" {
    name = "sm_role"
    assume_role_policy = file("${path.module}/policy_json/state_machine_assume_role_policy.json")
    managed_policy_arns = [aws_iam_policy.state_machine_policy.arn]
}
