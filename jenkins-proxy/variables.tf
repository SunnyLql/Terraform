variable "aws_region" {
  default = "us-west-2"
}


variable "public_key_location" {  
    default = "/home/sunnyq/.ssh/id_rsa.pub"
 }

variable "instance_type"{ 
    default= "t2.micro"
}

variable "website_jenkins"{ 
    default= "jenkinssl.courtcanva.com"
}

variable "health_check_path"{ 
    default= "/login"
}

