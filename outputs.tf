##############################################
# lambda_s3_image_compression outputs

output "s3_bucket_names" {
    value = [
            module.lambda_s3_compression.source_bucket,
            module.lambda_s3_compression.processed_bucket
            ]
}

