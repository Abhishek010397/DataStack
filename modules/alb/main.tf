resource "aws_lb" "alb_flask_app" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.alb_public_subnet_ids[0],var.alb_public_subnet_ids[1],var.alb_public_subnet_ids[2]]
  tags = var.tags
}

resource "aws_lb_target_group" "alb_flask_tg" {
  name        = var.alb_tg_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  tags        = var.tags

  health_check {
    path = "/health"
  }

}

resource "aws_lb_listener" "flask_lb_listener" {
  load_balancer_arn = aws_lb.alb_flask_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      protocol        = "HTTP"
      port            = "3000"
      status_code     = "HTTP_301"
    }
  }
}