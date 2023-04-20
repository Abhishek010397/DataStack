output "secret_id" {
    value = aws_secretsmanager_secret.rds_secret.arn
}