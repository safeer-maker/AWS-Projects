##############################################
# lambda_s3_image_compression outputs

# output "s3_bucket_names" {
#     value = [
#             module.lambda_s3_compression.source_bucket,
#             module.lambda_s3_compression.processed_bucket
#             ]
# }

# output "name" {
#     value = module.lambda_s3_compression.user_id
  
# }


##############################################
# lambda_ses_email_notification outputs

output "lambda_arn" {
    value = module.email_notification.lambda_arn
}
