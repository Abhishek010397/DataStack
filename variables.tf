
variable "vpc_cidr_block" {
    type = string
}
variable "vpc_id" {
    type = string
}

variable "aws_account_id" {
    type = string
}

variable "allocated_storage" {
    type = string
}
variable "db_identifier" {
    type = string
}

variable "storage_type" {
    type = string
}

variable "database_engine" {
    type = string
}

variable "database_engine_version" {
    type = string
}

variable "instance_class" {
    type = string
}

variable "db_dbname" {
    type = string
}

variable "db_username" {
    type = string
}

variable "db_password" {
    type = string
}

variable "monitoring_interval" {
    type = string
}
variable "maintenance_window" {
    type = string
}

variable "backup_window" {
    type = string
}

variable "backup_retention_period" {
    type = string
}

variable "kms_key_id" {
    type = string
}

variable "rds_secret_name" {
    type = string
}

variable "ecr_repo_name" {
  type = string
}

variable "nlb_name"{
    type = string
}

variable "nlb_tg_name" {
    type = string
}

variable "rds_subnet_group_name" {
    type = string
}

variable "nlb_sg_name" {
    type = string
}

variable "s3_bucket_name" {
    type = string
}

variable "s3_bucket_key" {
    type = string
}

variable "s3_object_upload"{
    type = string 
}

variable "lambda_role_name" {
    type = string
}

variable "lambda_policy_name" {
    type = string
}

variable "lambda_source_file" {
    type = string
}

variable "lambda_function_name" {
    type = string
}

variable "lambda_security_group_name" {
    type = string
}

variable "db_port" {
    type = number
}

variable "rds_sg_name" {
    type = string
}

variable "batch_instance_ami" {
    type = string
}

variable "batch_instance_instance_type" {
    type = string
}

variable "batch_instance_key_pair_name" {
    type = string
}

variable "batch_instance_volume_size" {
    type =string
}

variable "batch_instance_volume_type" {
    type = string
}

variable "batch_instance_sg_name" {
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

variable "asg_instance_name" {
    type = string
}

variable "asg_ebs_device_name" {
    type = string
}

variable "asg_ebs_volumes_size" {
    type = number
}

variable "asg_ebs_volumes_type" {
    type = string
}

variable "asg_instance_ami_id" {
    type = string
}

variable "asg_instance_type" {
    type = string
}

variable "asg_instance_key_name" {
    type = string
}

variable "asg_desired_capacity" {
    type = number
}

variable "asg_maximum_capacity" {
    type = number
}

variable "asg_minimum_capacity" {
    type = number
}

variable "asg_sg_name" {
    type = string
}

variable "asg_name" {
    type = string
}