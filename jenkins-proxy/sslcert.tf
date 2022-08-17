
resource "aws_acm_certificate" "jenkins_cert" {
  domain_name       = var.jenkins_cert_domain_name
  validation_method = "DNS"

  tags = {
    name  = "jenkinscert"
    Key   = "certificate"
    Value = "Jenkins certificate"
  }
  lifecycle {
    create_before_destroy = true
  }

}

# DNS Validation
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.jenkins_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.jenkins_record : record.fqdn]
}


resource "aws_route53_record" "jenkins_record" {
  for_each = {
    for dvo in aws_acm_certificate.jenkins_cert.domain_validation_options : dvo.domain_name => {
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
  zone_id         = "Z063690631XYTC15Y2L9C"
}



#------------------------------dnsA_record------------------------
resource "aws_route53_record" "jenkins_record_atype" {
  zone_id = "Z063690631XYTC15Y2L9C"
  name    = aws_acm_certificate.jenkins_cert.domain_name
  type    = "A"

  alias {

    name                   = aws_alb.jenkins-alb.dns_name
    zone_id                = aws_alb.jenkins-alb.zone_id
    evaluate_target_health = true
  }
}
