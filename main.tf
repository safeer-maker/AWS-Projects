# # Image compression module
# module "lambda_s3_compression" {
#   source = "./module/lambda_s3_image_compression"
  
# }
module "email_notification" {
  source = "./module/lambda_ses_email_notification"
}
