# IAM policies 

resource "aws_iam_policy" "lambda_ses_policy" {
    name = "lambda_ses_policy"
    description = "Allow lambda to send email using SES"
    policy = file("${path.module}/policy_json/lambda_ses_policy.json")
}