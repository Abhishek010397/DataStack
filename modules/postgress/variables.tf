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

variable "tags" {
    type = map(string)
}

variable "subnet_ids" {
    type = list(string)
}

variable "rds_subnet_group_name" {
    type = string
}

variable "db_port" {
    type = number
}

variable "rds_db_security_groups" {
    type = string
}