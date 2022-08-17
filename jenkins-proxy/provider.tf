terraform {
  required_version = ">= 0.12"
}

provider "aws" {

  region = "ap-southeast-2"
  #shared_credentials_file = "%USERPROFILE%/.aws/credentials"
  default_tags {
    tags = {
      name    = "JenkinsEC2"
      Project = "Courtcanva"
    }
  }
}

terraform {
  backend "s3" {
    key            = "uat/jenkins-ec2/terraform.tfstate"
    region         = "ap-southeast-2"
    bucket         = "cc-terraform-state-file"
    dynamodb_table = "terraform-state-locking"
    #encrypt = true # Optional, S3 Bucket Server Side Encryption
  }
}
