locals {
  local_count     = 3
  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  region          = "ap-southeast-1"
  tags = {
    CreatedBy   = "Terraform"
  }
}

#Deploy Security Groups/public Subnets 
module "networking" {
  source                      = "./modules/networking"
  local_count                 = local.local_count
  vpc_cidr_block              = var.vpc_cidr_block
  vpc_id                      = var.vpc_id
  nlb_sg_name                 = var.nlb_sg_name
  asg_sg_name                 = var.asg_sg_name 
  rds_sg_name                 = var.rds_sg_name 
  lambda_security_group_name  = var.lambda_security_group_name
  batch_instance_sg_name      = var.batch_instance_sg_name
  azs                         = local.azs
  region                      = local.region
  tags                        = local.tags
}

# Deploy IAM Role & Policy
module "iam" {
  source                         = "./modules/iam"
  aws_account_id                 = var.aws_account_id  
  asg_instance_role_name         = var.asg_instance_role_name
  asg_instance_profile_role_name = var.asg_instance_profile_role_name
  asg_instance_policy_name       = var.asg_instance_policy_name
  secret_id                      = module.secrets_manager.secret_id
  s3_bucket_name                 = module.block_storage.aws_config_bucket_name
  lambda_role_name               = var.lambda_role_name
  lambda_policy_name             = var.lambda_policy_name
  instance_profile_role_name     = var.instance_profile_role_name
  iam_policy_name                = var.iam_policy_name
  instance_role_name             = var.instance_role_name
  region                         = local.region
  tags                           = local.tags
}

#Deploy DB
module "postgress" {
    source                       = "./modules/postgress"
    allocated_storage            = var.allocated_storage
    db_identifier                = var.db_identifier
    storage_type                 = var.storage_type
    database_engine              = var.database_engine
    database_engine_version      = var.database_engine_version
    instance_class               = var.instance_class
    rds_subnet_group_name        = var.rds_subnet_group_name 
    rds_db_security_groups       = module.networking.db_sg_id
    db_dbname                    = var.db_dbname
    db_username                  = var.db_username
    db_password                  = var.db_password
    db_port                      = var.db_port
    monitoring_interval          = var.monitoring_interval
    maintenance_window           = var.maintenance_window
    backup_window                = var.backup_window
    backup_retention_period      = var.backup_retention_period
    kms_key_id                   = var.kms_key_id
    tags                         = local.tags
    subnet_ids                   = module.networking.public_subnet_ids
}

#Deploy Secrets
module "secrets_manager" {
  source           = "./modules/secrets_manager"
  rds_secret_name  = var.rds_secret_name
  db_username      = var.db_username
  db_dbname        = var.db_dbname
  db_password      = var.db_password
  db_host          = module.postgress.postgress_rds_endpoint
}

#Deploy ECR
module "ecr" {
    source        = "./modules/ecr"
    ecr_repo_name = var.ecr_repo_name
}

#Deploy NLB
module "nlb" {
    source                     = "./modules/nlb"
    nlb_name                   = var.nlb_name
    nlb_sg_id                  = module.networking.nlb_sg_id
    nlb_public_subnet_ids      = module.networking.public_subnet_ids
    nlb_tg_name                = var.nlb_tg_name
    vpc_id                     = var.vpc_id
    tags                       = local.tags

}

#Deploy S3
module "block_storage" {
    source              = "./modules/block_storage"
    s3_bucket_name      = var.s3_bucket_name
    s3_bucket_key       = var.s3_bucket_key
    s3_object_upload    = var.s3_object_upload
    aws_account_id      = var.aws_account_id
    lambda_function_arn = module.lambda.batch_job_lambda_arn
    tags                = local.tags
}

#Deploy Lambda
module "lambda" {
  source                     = "./modules/lambda"
  lambda_source_file         = var.lambda_source_file
  lambda_function_name       = var.lambda_function_name
  s3_bucket_arn              = module.block_storage.aws_config_bucket_arn
  public_subnet_ids          = module.networking.public_subnet_ids
  iam_role_lambda            = module.iam.lambda_execution_role_arn
  lambda_security_group_id   = module.networking.lambda_security_group_id
  instance_id                = module.compute.batch_instance_id
}

##Deploy Compute
module "compute" {
  source                                =  "./modules/compute"
  batch_instance_ami                    = var.batch_instance_ami
  batch_instance_instance_type          = var.batch_instance_instance_type
  batch_instance_key_pair_name          = var.batch_instance_key_pair_name
  batch_instance_volume_size            = var.batch_instance_volume_size
  batch_instance_volume_type            = var.batch_instance_volume_type
  batch_instance_vpc_security_group_ids = module.networking.batch_sg_id
  public_subnet_ids                     = module.networking.public_subnet_ids
  batch_instance_role_name              = module.iam.aws_batch_instance_role_name
  tags                                  = local.tags
}

##Deploy ASG for Flask Application
module "autoscaling_grous" {
  source                              = "./modules/autoscaling_groups"
  asg_instance_name                   = var.asg_instance_name
  asg_ebs_device_name                 = var.asg_ebs_device_name
  asg_ebs_volume_size                 = var.asg_ebs_volumes_size
  asg_ebs_volume_type                 = var.asg_ebs_volumes_type
  asg_instance_ami_id                 = var.asg_instance_ami_id
  asg_instance_type                   = var.asg_instance_type
  asg_instance_key_name               = var.asg_instance_key_name
  ebs_asg_security_groups             = module.networking.asg_sg_id
  asg_desired_capacity                = var.asg_desired_capacity
  asg_maximum_capacity                = var.asg_maximum_capacity
  asg_minimum_capacity                = var.asg_minimum_capacity
  asg_instance_profile_role_name      = module.iam.asg_instance_role_name
  public_subnet_ids                  = module.networking.public_subnet_ids
  lb_target_group_arn                 = module.nlb.nlb_target_group_arn
  asg_name                            = var.asg_sg_name
  tags                                = local.tags
}