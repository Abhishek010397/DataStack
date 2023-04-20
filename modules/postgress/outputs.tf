output "postgress_rds_arn" {
  value = aws_db_instance.postgress_rds.arn
}

output "postgress_rds_endpoint" {
  value = aws_db_instance.postgress_rds.endpoint
}