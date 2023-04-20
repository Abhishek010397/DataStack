variable "s3_bucket_arn" {
    type = string
}

variable "public_subnet_ids" {
    type = list(string)
}

variable "lambda_source_file" {
    type = string
}

variable "lambda_function_name" {
    type = string
}

variable "iam_role_lambda" {
    type = string
}

variable "lambda_security_group_id" {
    type = string
}

variable "instance_id" {
    type = string
}
