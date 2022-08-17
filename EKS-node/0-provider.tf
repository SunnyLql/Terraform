terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
 
}

variable "aws_region" {
  default = "ap-southeast-2"
}

variable "cluster_name" {
  default = "eks-ccs"
}

variable "cluster_version" {
  default = "1.22"
}