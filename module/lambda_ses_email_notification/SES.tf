
# Email identity for SES
resource "aws_ses_email_identity" "name" {
    email = var.email_1
}