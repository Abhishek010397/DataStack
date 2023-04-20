variable "asg_instance_name" {
    type = string
}

variable "asg_ebs_device_name" {
    type = string
    default = "/dev/xvda"
}

variable "asg_ebs_volume_size" {
    type = number
    default = 8
}

variable "asg_ebs_volume_type" {
    type = string
    default = "gp2"
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

variable "ebs_asg_security_groups" {
    type = string
}

variable "asg_desired_capacity" {
    type = string
}

variable "asg_maximum_capacity" {
    type = string
}

variable "asg_minimum_capacity" {
    type = string
}

variable "tags" {
  type = map(string)
}

variable "asg_instance_profile_role_name" {
    type = string
}

variable "public_subnet_ids" {
    type = list(string)
}

variable "lb_target_group_arn" {
    type = string
}

variable "asg_name" {
    type = string
}