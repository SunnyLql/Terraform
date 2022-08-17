resource "aws_alb" "jenkins-alb" {
  name               = var.jenkins_alb_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  #vpc_id             = aws_vpc.main.id
  subnets = [aws_subnet.main.id, aws_subnet.main2.id]
  tags = {
    Name  = "Jenkins_ALB"
    Key   = "ALB"
    Value = "jenkins"
  }

  /* access_logs {
    bucket  = aws_s3_bucket.alb_log.bucket
    prefix  = "jenkins"
    enabled = true
  } */

}


resource "aws_security_group" "alb_sg" {
  name        = "alb_sg_jenkins"
  description = "alb sg with jenkins ec2 as tg "
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "Jenkins_ALB_SG"
  }
}

resource "aws_security_group_rule" "alb_irule_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #"::/0"
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_irule_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #"::/0"
  security_group_id = aws_security_group.alb_sg.id
}


resource "aws_security_group_rule" "alb_erule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #"::/0"
  security_group_id = aws_security_group.alb_sg.id
}


#create target group
resource "aws_lb_target_group" "jenkins" {
  name     = "jenkins-alb-tg-tf"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    port     = 8080
    path     = "/login"
    protocol = "HTTP"
  }

}


#registered as target in target group
resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = aws_lb_target_group.jenkins.arn
  target_id        = aws_instance.jenkins_host.id
  port             = 8080
}



resource "aws_lb_listener" "jenkins-listener" {
  load_balancer_arn = aws_alb.jenkins-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06" #ALB policy
  certificate_arn   = aws_acm_certificate.jenkins_cert.arn

  default_action {
    target_group_arn = aws_lb_target_group.jenkins.arn
    type             = "forward"
  }
}
