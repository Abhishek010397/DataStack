#!/bin/bash

aws s3 sync s3://rds-db-config-bucket/config . --region ap-southeast-1

secret_string=$(aws secretsmanager get-secret-value --secret-id flaskapp/rds/rds-postgres-secret --query SecretString --output text --region ap-southeast-1)

db_password=$(echo "$secret_string" | jq -r '.DB_PASSWORD')
db_user=$(echo "$secret_string" | jq -r '.DB_USER')
db_dbname=$(echo "$secret_string" | jq -r '.DB_NAME')
db_hst=$(echo "$secret_string" | jq -r '.DB_HOST')

db_host=${db_hst%%:*}
db_port=${db_hst#*:}

PGPASSWORD=$db_password psql -U $db_user -h $db_host -p $db_port $db_dbname < rates.sql

PGPASSWORD=$db_password psql -U $db_user -h $db_host -p $db_port $db_dbname -c "SELECT 'alive'"