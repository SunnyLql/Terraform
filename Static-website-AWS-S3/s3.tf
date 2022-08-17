resource "aws_s3_bucket" "aw_static_web" {
  bucket = var.aw_static_web
  acl    = "public-read"
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.aw_static_web}/*"]
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  tags = {
    Name  = "Front-end S3"
    Owner = var.environment
  }
  #tags = var.static_web_tags
}

