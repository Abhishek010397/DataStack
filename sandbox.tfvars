vpc_cidr_block                = "172.31.0.0/16"
vpc_id                        = "vpc-a6a862c0"
aws_account_id                = "784364363154"
rds_subnet_group_name         = "rds-db-subet-group"
allocated_storage             = 20
db_identifier                 = "sandbox-rds"
storage_type                  = "gp2"
database_engine               = "postgres"
database_engine_version       = 13.5
rds_sg_name                   ="RDSSg"
instance_class                = "db.t3.micro"
db_dbname                     = "rdsdatabasepostgres"
db_username                   = "postgresadminuser"
db_password                   = "REPLACEME"
db_port                       = 5432
monitoring_interval           = 0
maintenance_window            = "sun:07:00-sun:08:00"
backup_window                 = "05:00-06:00"
backup_retention_period       =  7
kms_key_id                    = "arn:aws:kms:ap-southeast-1:784364363154:key/3a7d47e7-9810-4aae-ab58-1ceadd8b3c0d"
rds_secret_name               = "flask/rds/rds-postgres-secret"
ecr_repo_name                 = "flask-app-repo"
alb_name                      = "app-alb"
alb_tg_name                   = "app-target-group"
alb_sg_name                   = "ALBSg"
asg_sg_name                   = "ASGAppSg"
s3_bucket_name                = "rds-db-config-bucket"
s3_bucket_key                 = "config/rates.sql"
s3_object_upload              = "./operations-task/db/rates.sql"
lambda_role_name              = "LambdaBatchRole"
lambda_policy_name            = "LambdaBatchPolicy"
lambda_source_file            = "./lambda_function/lambda_function.zip"
lambda_function_name          = "batch_job"
lambda_security_group_name    = "LambdaBatchSg"
batch_instance_volume_size    = 8
batch_instance_volume_type    = "gp2"
batch_instance_ami            = "ami-0ce792959cf41c394"
batch_instance_instance_type  = "t2.micro"
batch_instance_key_pair_name  = "my_ec2_key"
batch_instance_sg_name        = "BatchSg"
instance_profile_role_name    = "EC2BatchRole"
iam_policy_name               = "EC2BatchPolicy"
instance_role_name            = "BatchEC2Role"
asg_instance_policy_name      = "S3SecretsInstancePolicy"
asg_instance_role_name        = "ASGAppRole"
asg_instance_profile_role_name= "ASGAppInstanceProfile"
asg_instance_name             = "FlaskAppServer"
asg_ebs_device_name           = "/dev/xvda"
asg_ebs_volumes_size          = 8
asg_ebs_volumes_type          = "gp2"
asg_instance_ami_id           = "ami-0ce792959cf41c394"
asg_instance_type             = "t2.micro"
asg_instance_key_name         = "my_ec2_key"
asg_desired_capacity          = 3
asg_maximum_capacity          = 3
asg_minimum_capacity          = 3
asg_name                      = "FlaskAppServerInstance"
