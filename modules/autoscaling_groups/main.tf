data "template_file" "user_data" {
  template = file("start.sh.tpl")
}

resource "aws_launch_template" "asg_launch_template" {
  name                   = var.asg_instance_name
  update_default_version = true

  block_device_mappings {
    device_name = var.asg_ebs_device_name

    ebs {
      volume_size           = var.asg_ebs_volume_size
      volume_type           = var.asg_ebs_volume_type
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name  = var.asg_instance_profile_role_name
  }

  image_id                             = var.asg_instance_ami_id
  instance_type                        = var.asg_instance_type
  key_name                             = var.asg_instance_key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  user_data              = base64encode(data.template_file.user_data.rendered)
  vpc_security_group_ids = [var.ebs_asg_security_groups]

  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = var.tags
  }

}

resource "aws_autoscaling_group" "asg-aws" {
  name                      = var.asg_name
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_maximum_capacity
  min_size                  = var.asg_minimum_capacity
  vpc_zone_identifier       = [var.public_subnet_ids[0], var.public_subnet_ids[1], var.public_subnet_ids[2]]
  target_group_arns         = [var.lb_target_group_arn]

  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
    }
    triggers = ["tag"]
  }

  tag {
    key                 = "CreatedBy"
    value               = "Terraform"
    propagate_at_launch = true
}

}

