provider "aws" {
  alias  = "acm"
  region = "ap-southeast-2"
  #  version = "2.24"
}


resource "aws_acm_certificate" "alb-backend" {
  provider                  = "aws.acm"
  domain_name               = var.website_name
  subject_alternative_names = ["*.${var.website_name}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}



data "aws_route53_zone" "public_zone" {
  name         = "courtcanva.com" #var.cc_hostedzone
  private_zone = false
}

resource "aws_route53_record" "alb-backend" {

  # zone_id = "${data.aws_route53_zone.public_zone.zone_id}"
  # name = "${aws_acm_certificate.alb-backend.domain_validation_options.0.resource_record_name}"
  # type = "${aws_acm_certificate.alb-backend.domain_validation_options.0.resource_record_type}"
  # records = ["${aws_acm_certificate.alb-backend.domain_validation_options.0.resource_record_value}"]
  # ttl = "300"

  for_each = {
    for dvo in aws_acm_certificate.alb-backend.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public_zone.zone_id
}



resource "aws_acm_certificate_validation" "alb-backend" {
  provider                = "aws.acm"
  certificate_arn         = aws_acm_certificate.alb-backend.arn
  validation_record_fqdns = [for record in aws_route53_record.alb-backend : record.fqdn]
  # validation_record_fqdns = [
  #   "${aws_route53_record.alb-backend.fqdn}",
  # ]

}


