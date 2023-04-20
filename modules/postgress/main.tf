
#RDS Private Subnet Group
resource "aws_db_subnet_group" "postgress_rds_dbsubnet" {
  name       = var.rds_subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

#RDS IN 2 Private Subnets
resource "aws_db_instance" "postgress_rds" {
  allocated_storage                   = var.allocated_storage
  identifier                          = var.db_identifier
  storage_type                        = var.storage_type
  engine                              = var.database_engine
  engine_version                      = var.database_engine_version
  instance_class                      = var.instance_class
  multi_az                            = true 
  db_name                             = var.db_dbname
  username                            = var.db_username
  password                            = var.db_password
  db_subnet_group_name                = aws_db_subnet_group.postgress_rds_dbsubnet.name
  vpc_security_group_ids              =[var.rds_db_security_groups]
  publicly_accessible                 = true
  storage_encrypted                   = true
  iam_database_authentication_enabled = false
  deletion_protection                 = false
  auto_minor_version_upgrade          = true
  monitoring_interval                 = var.monitoring_interval 
  maintenance_window                  = var.maintenance_window
  backup_window                       = var.backup_window
  backup_retention_period             = var.backup_retention_period
  kms_key_id                          = var.kms_key_id
  skip_final_snapshot                 = true
  copy_tags_to_snapshot               = true
  port                                = var.db_port
  tags                                = var.tags
}