// This Route53 record will point at our CloudFront distribution.
resource "aws_route53_record" "dns" {
  zone_id = "${data.aws_route53_zone.public_zone.zone_id}"
  name    = "${var.website_name}"
  type    = "A"

  alias  {
    name                   = "${aws_cloudfront_distribution.main.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.main.hosted_zone_id}"
    evaluate_target_health = false
  }
}