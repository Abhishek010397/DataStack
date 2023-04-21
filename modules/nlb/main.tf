#NLB
resource "aws_lb" "nlb_flask_app" {
  name               = var.nlb_name
  internal           = false
  load_balancer_type = "network"
  subnets            = [var.nlb_public_subnet_ids[0],var.nlb_public_subnet_ids[1],var.nlb_public_subnet_ids[2]]

  # enable_deletion_protection = true

  tags = var.tags
}

resource "aws_lb_target_group" "nlb_flask_tg" {
  name        = var.nlb_tg_name
  port        = 3000
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  tags        = var.tags

}

resource "aws_lb_listener" "flask_lb_listener" {
  load_balancer_arn = aws_lb.nlb_flask_app.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_flask_tg.arn
  }
  tags = var.tags
}