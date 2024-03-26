
# Email identity for SES
resource "aws_ses_email_identity" "primary_mail" {
    email = var.email_primary
}

resource "aws_ses_email_identity" "seconday_mail" {
    email = var.email_secondary
}