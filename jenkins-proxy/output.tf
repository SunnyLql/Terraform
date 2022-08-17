output "jenkins-ip" {
  value = aws_instance.jenkins-instance.public_ip
}

output "alb_hostname" {
  value = aws_alb.jenkins.dns_name
}

