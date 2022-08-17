# alb.tf

resource "aws_alb" "jenkins" {
  name            = "jenkins-load-balancer"
  subnets         = aws_subnet.demo.*.id
  security_groups = [aws_security_group.alb-jenkins.id]
}

resource "aws_alb_target_group" "jenkins" {
  name        = "jenkins-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.demo.id
  target_type = "instance"
 
 
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200-304"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

 resource "aws_alb_target_group_attachment" "jenkins" {
  target_group_arn = aws_alb_target_group.jenkins.arn
  target_id        = aws_instance.jenkins-instance.id
  port             = 8080
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.jenkins.id
  port              = 80
  protocol          = "HTTP"

    default_action {
   type = "redirect"
 
   redirect {
     port        = 443
     protocol    = "HTTPS"
     status_code = "HTTP_301"
   }
  }
}
 resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.jenkins.id
  port              = 443
  protocol          = "HTTPS"
 
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.alb-jenkins.arn

  default_action {
    target_group_arn = aws_alb_target_group.jenkins.id
    type             = "forward"
  }
}