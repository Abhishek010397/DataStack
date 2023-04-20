data "template_file" "user_data" {
  template = file("startup.sh.tpl")
}

resource "aws_instance" "batch_instance" {
  ami                    = var.batch_instance_ami
  instance_type          = var.batch_instance_instance_type
  key_name               = var.batch_instance_key_pair_name
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.batch_instance_vpc_security_group_ids]
  source_dest_check      = false
  ebs_optimized          = false
  user_data              = base64encode(data.template_file.user_data.rendered)
  iam_instance_profile   = var.batch_instance_role_name
  root_block_device {
    volume_size           = var.batch_instance_volume_size
    volume_type           = var.batch_instance_volume_type
    delete_on_termination = true
  }
  tags = var.tags
}
