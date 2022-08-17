resource "aws_route53_record" "alb-dns" {
  zone_id = data.aws_route53_zone.public_zone.zone_id
  name    = "${var.website_name}"
  type    = "A"

  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = true
  }
}

