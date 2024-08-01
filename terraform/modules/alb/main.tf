resource "aws_lb" "webapplication" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_http2 = true

  enable_deletion_protection = false

  tags = {
    Name = var.name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.webapplication.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.webapplication.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.webapplication.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.webapplication.arn
  }

  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = var.certificate_arn
}

resource "aws_lb_target_group" "webapplication" {
  name     = "${var.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.name}-tg"
  }
}
