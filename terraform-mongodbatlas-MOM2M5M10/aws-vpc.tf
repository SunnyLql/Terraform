provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

//Create Primary VPC
resource "aws_vpc" "primary" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    name = "CC-mongodbatlas-UAT"
  }  
}

//Create IGW
resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id
}

//Route Table
resource "aws_route" "primary-internet_access" {
  route_table_id         = aws_vpc.primary.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary.id
}

//Subnet-A
resource "aws_subnet" "primary-az1" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  
    tags = {
    name = "CC-mongodbatlas-UAT"
  }  
}

//Subnet-B
# resource "aws_subnet" "primary-az2" {
#   vpc_id                  = aws_vpc.primary.id
#   cidr_block              = "10.0.2.0/24"
#   map_public_ip_on_launch = false
#   availability_zone       = "${var.aws_region}b"
# }

/*Security-Group
Ingress - Port 80 -- limited to instance
          Port 22 -- Open to ssh without limitations
Egress  - Open to All*/

resource "aws_security_group" "primary_default" {
  name_prefix = "default-"
  description = "Default security group for all instances in ${aws_vpc.primary.id}"
  vpc_id      = aws_vpc.primary.id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      aws_vpc.primary.cidr_block,
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
    name = "CC-mongodbatlas-UAT"
  }  
}

 //VPC Peer Device to ATLAS Route Table Association on AWS
resource "aws_route" "peeraccess" {
  route_table_id            = aws_vpc.primary.main_route_table_id
  destination_cidr_block    = var.atlas_vpc_cidr
  vpc_peering_connection_id = mongodbatlas_network_peering.aws-atlas.connection_id
  depends_on                = [aws_vpc_peering_connection_accepter.peer]
}


 //AWS VPC Peer Conf
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = mongodbatlas_network_peering.aws-atlas.connection_id
  auto_accept               = true
}
 
 #This creates an ec2 instance with tags but does NOT contain the logic necessary to place the instance in the newly created VPC, or pull the pem key file.
#Uncomment the sections below if you want to create the ec2 instance along with the rest of this script

resource "aws_instance" "instance" {
  ami                         = "ami-0cb4e786f15603b0d"
  availability_zone           = "${var.aws_region}a"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.primary-az1.id
  
  tags = {
    name = "test-EC2"
    owner = "name_here"
    expire-on = "expiry_date"
    purpose = "training"
    
  }
}
