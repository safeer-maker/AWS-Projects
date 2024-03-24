output "source_bucket" {
    value = aws_s3_bucket.source_bucket.id
}

output "processed_bucket" {
    value = aws_s3_bucket.processed_bucket.bucket
}

output "user_id" {
    value = data.aws_caller_identity.current.account_id
}