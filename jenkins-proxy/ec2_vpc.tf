#------------------------------JenkinsVPC-------------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"
  tags = {
    Name = "Jenknis"
  }
}
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "Jenkins_subnet"
  }
}
resource "aws_subnet" "main2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-2b"
  tags = {
    Name = "Jenkins_subnet2"
  }
}

resource "aws_internet_gateway" "jenkins-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "jenkins-igw"
  }
}
resource "aws_route_table" "jenkins_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins-igw.id
  }

}

resource "aws_route_table_association" "jenkins-public-subnet-1" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.jenkins_route_table.id
}
#------------------------------JenkinsSecurityGroup-------------------------------
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_ec2_sg"
  description = "jenkins_ec2_sg"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "Jenknis"
  }
}

resource "aws_security_group_rule" "jenkins_irule_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #"::/0"
  security_group_id = aws_security_group.jenkins_sg.id
}

resource "aws_security_group_rule" "jenkins_irule_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #"::/0"
  security_group_id = aws_security_group.jenkins_sg.id
}

resource "aws_security_group_rule" "jenkins_irule_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #"::/0"
  security_group_id = aws_security_group.jenkins_sg.id
}

resource "aws_security_group_rule" "jenkins_irule_http1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #"::/0"
  security_group_id = aws_security_group.jenkins_sg.id
}

resource "aws_security_group_rule" "jenkins_erule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #"::/0"
  security_group_id = aws_security_group.jenkins_sg.id
}






#-----------------------------------------JenkinsEc2-------------------------------------
data "aws_key_pair" "example" {
  key_name = "jenkinsec2keypair"
  filter {
    name   = "tag:KeyPair"
    values = ["JenkinsKey"]
  }
}

/*data "aws_eip" "jenkins_eip" {
  filter {
    name   = "tag:Name"
    values = ["jenkinsec2"]
  }
}*/

resource "aws_instance" "jenkins_host" {
  ami                         = var.aw_ami
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.main.id
  key_name                    = "jenkinsec2keypair"
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  user_data                   = file("user_data.sh")
  tags = {
    Key   = "EC2"
    Value = "Jenkins"
    Name  = "Jenknis"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = "40"
  }
}




resource "aws_eip_association" "jenkins_eip_assos" {
  instance_id   = aws_instance.jenkins_host.id
  allocation_id = var.aws_eip_id
}


/*resource "aws_ebs_volume" "jenkins_volume_ebs" {
  availability_zone = "ap-southeast-2c"
  size              = "50"
  type              = "gp2"
  tags = {
    Name = "Jenknis"
  }
  lifecycle {
    prevent_destroy = false
  }

}*/
resource "aws_volume_attachment" "jenkins_volume_ebs_att" {
  device_name = "/dev/sdh" #name seen in ebs volume, in ec2 it is "/dev/nvme1n1" 
  volume_id   = var.jenkins_volume
  instance_id = aws_instance.jenkins_host.id
}
