variable "s3_bucket_name" {
    type = string
}

variable "aws_account_id" {
    type = string
}

variable "tags" {
    type = map(string)
}

variable "s3_bucket_key" {
    type = string
}

variable "s3_object_upload" {
    type = string
}

variable "lambda_function_arn" {
  type = string
}