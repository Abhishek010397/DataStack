output "aws_config_bucket_name" {
  value = aws_s3_bucket.config_bucket.id
}

output "aws_config_bucket_arn" {
  value = aws_s3_bucket.config_bucket.arn
}