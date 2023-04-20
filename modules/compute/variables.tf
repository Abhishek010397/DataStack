variable "tags" {
    type = map(string)
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

variable "public_subnet_ids" {
    type = list(string)
}

variable "batch_instance_vpc_security_group_ids" {
    type = string
}

variable "batch_instance_volume_size" {
    type =string
}

variable "batch_instance_volume_type" {
    type = string
}

variable "batch_instance_role_name" {
    type = string
}