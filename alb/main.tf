resource "aws_lb_target_group" "main" {
  name     = "${var.alb_target_group_name}"
  port     = "${var.alb_target_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb" "main" {
  name            = "${var.alb_name}"
  subnets         = "${var.subnet_ids}"
  security_groups = "${var.security_groups}"
}

resource "aws_lb_listener" "front_end_tls" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2015-05"
  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.main.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "enforce_https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
