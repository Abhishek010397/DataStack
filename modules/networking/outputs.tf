output "public_subnet_ids" {
  value = aws_subnet.public-subnet.*.id
}

output "nlb_sg_id" {
  value = aws_security_group.nlb_sg.id
}

output "asg_sg_id" {
  value = aws_security_group.asg_sg.id
}

output "lambda_security_group_id" {
  value = aws_security_group.lambda_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id 
}

output "batch_sg_id" {
  value = aws_security_group.batch_sg.id
}