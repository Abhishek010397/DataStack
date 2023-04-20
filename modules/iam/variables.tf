variable "tags" {
  type = map(string)
}

variable "aws_account_id" {
    type = string
}

variable "secret_id" {
    type = string
}

variable "lambda_role_name" {
    type = string
}

variable "lambda_policy_name" {
    type = string
}

variable "s3_bucket_name" {
    type = string
}

variable "region" {
    type = string
}

variable "instance_profile_role_name" {
    type = string
}

variable "iam_policy_name" {
    type = string
}

variable "instance_role_name" {
    type = string
}

variable "asg_instance_policy_name" {
    type = string
}

variable "asg_instance_role_name" {
    type = string
}

variable "asg_instance_profile_role_name" {
    type = string
}