output "aws_webserver_launch_template_id" {
  value = aws_launch_template.asg_launch_template.id
}

output "aws_webserver_launch_template_version" {
  value = aws_launch_template.asg_launch_template.latest_version
}
