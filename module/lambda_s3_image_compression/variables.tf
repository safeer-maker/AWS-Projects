variable "source_bucket_name" {
    type = string
    default = "lambda-s3-source-bucket-143"
    description = "The name of the source bucket"
}

variable "processed_bucket_name" {
    type = string
    default = "lambda-s3-processed-bucket-143"
    description = "The name of the processed bucket"
}
