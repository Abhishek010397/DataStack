variable "alb_name"{
    type = string
}

variable "alb_sg_id" {
    type = string
}

variable "alb_public_subnet_ids" {
    type = list(string)
}

variable "alb_tg_name" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "tags" {
    type = map(string)
}