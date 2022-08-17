output "web-domain" {
  value = aws_s3_bucket.ccbucket.bucket_regional_domain_name
  # this is origin name for CDN
}

output "web-endpoint" {
  value = aws_s3_bucket.ccbucket.website_domain

}

output "website" {
  value = aws_s3_bucket.ccbucket.website

}

output "website_endpoint" {
  value = aws_s3_bucket.ccbucket.website_endpoint

}
output "website-id" {
  value = aws_s3_bucket.ccbucket.id

}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.main.*.domain_name
}


output "cdn_cert" {
  #value = module.cdn_cert.cdn_cert_us
  value = aws_acm_certificate.default.arn


}