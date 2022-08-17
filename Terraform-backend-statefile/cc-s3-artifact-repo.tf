resource "aws_s3_bucket" "repo_bucket" {
  bucket = "frontend.artifact.repo"
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::frontend.artifact.repo/*"
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*Object",
            "Resource": "arn:aws:s3:::frontend.artifact.repo/*"
        }
    ]
}
  POLICY
  tags = {
    Name = "front-end-repo"
  }

}
resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.repo_bucket.id
  ignore_public_acls  = true
  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_acl" "repo_bucket_acl" {
  bucket = aws_s3_bucket.repo_bucket.id
  acl    = "private"
}
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.repo_bucket.id
  acl    = "private"
  key    = "courtcanva.app.artifact.repo/"
}