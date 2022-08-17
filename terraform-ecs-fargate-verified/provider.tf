
# provider.tf

# Specify the provider and access details
provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
  region                  = var.aws_region
default_tags {
    tags = {
      Environment = "UAT"
      Project        = "Courtcanva"
    }
  }

}