resource "aws_route53_record" "alb-jenkins-dns" {
  zone_id = data.aws_route53_zone.public_zone.zone_id
  name    = "${var.website_jenkins}"
  type    = "A"

  alias {
    name                   = aws_alb.jenkins.dns_name
    zone_id                = aws_alb.jenkins.zone_id
    evaluate_target_health = true
  }
}