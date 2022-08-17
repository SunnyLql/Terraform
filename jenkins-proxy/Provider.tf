terraform {
  required_providers {
    aws = {
      source ="hashicorp/aws"
      version = ">=2.7.0"
    }
  }
}
provider "aws" {
#  shared_credentials_file = "$HOME/jenkins/.aws/credentials"
#  profile                 = "default"

  region = var.aws_region
default_tags {
    tags = {
      name = "JenkinsEC2"
      Project        = "Courtcanva"
    }
  }

}

data "aws_availability_zones" "available" {}


