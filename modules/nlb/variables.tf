variable "nlb_name"{
    type = string
}

variable "nlb_sg_id" {
    type = string
}

variable "nlb_public_subnet_ids" {
    type = list(string)
}

variable "nlb_tg_name" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "tags" {
    type = map(string)
}