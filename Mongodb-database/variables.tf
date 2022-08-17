variable "public_key" {
  description = "The public API key for MongoDB Atlas"
}
variable "private_key" {
  description = "The private API key for MongoDB Atlas"
}

/*variable "access_key" {
  description = "The access key for AWS Account"
}
variable "secret_key" {
  description = "The secret key for AWS Account"
}*/
variable "atlas_region" {
  default     = "ap-southeast-2"
  description = "Atlas Region"
}
variable "aws_region" {
  default     = "ap-southeast-2"
  description = "AWS Region"
}
variable "atlas_dbuser" {
  description = "The db user for Atlas"
}
variable "atlas_dbpassword" {
  description = "The db user passwd for Atlas"
}
variable "aws_account_id" {
  description = "My AWS Account ID"

}
variable "atlasorgid" {
  description = "Atlas Org ID"

}
variable "dbvpc" {

}
variable "dbsubnet" {

}
variable "atlas_vpc_cidr" {
  description = "Atlas CIDR"

}
variable "mongodbprojectname" {
  description = "DB Name"

}
variable "clustername" {
  description = "Cluster Name"

}

variable "environment" {
  type        = string
  description = "The environment (uat, prod, test, etc.)  for the website."
}
variable "ECSNatGatewayEIP" {

}

variable "statefilepath"{
  
}