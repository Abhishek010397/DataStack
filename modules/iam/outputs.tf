output "lambda_execution_role_arn" {
  value = aws_iam_role.iam_for_lambda.arn
}

output "aws_batch_instance_role_name" {
  value = aws_iam_instance_profile.instance_profile_role.name
}

output "asg_instance_role_name" {
  value = aws_iam_instance_profile.asg_instance_profile_role.name
}