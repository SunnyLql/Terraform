data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins-instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "${var.instance_type}"

   tags = {
    Name = "jenkinsmaster"
  }

  # the VPC subnet
  subnet_id = aws_subnet.demo.*.id[0]

  # the security group
  vpc_security_group_ids = [aws_security_group.sg-jenkins.id]

# vailability zone
  availability_zone       = data.aws_availability_zones.available.names[0]

  # the public SSH key
  key_name = aws_key_pair.ssh-key.key_name
 
  associate_public_ip_address = true 


  # user data
  user_data = file("jenkins_init.sh")

}