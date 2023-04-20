resource "aws_secretsmanager_secret" "rds_secret" {
  name = var.rds_secret_name
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    "DB_NAME"     = var.db_dbname,
    "DB_USER"     = var.db_username,
    "DB_PASSWORD" = var.db_password,
    "DB_HOST"     = var.db_host
  })
}