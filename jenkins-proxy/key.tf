resource "aws_key_pair" "ssh-key" {
  key_name   = "mykey"
  public_key = "${file(var.public_key_location)}"
}