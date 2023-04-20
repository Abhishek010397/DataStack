variable "tags" {
    type = map(string)
}

variable "vpc_id" {
    type = string
}

variable "local_count" {
    type = string
}

variable "vpc_cidr_block" {
    type = string
}

variable "azs" {
    type = list(string)
}

variable "region" {
    type = string
}

variable "alb_sg_name" {
  type = string
}

variable "asg_sg_name" {
    type = string
}

variable "lambda_security_group_name" {
    type = string
}

variable "rds_sg_name" {
    type = string
}

variable "batch_instance_sg_name" {
    type = string
}