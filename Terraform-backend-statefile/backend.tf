terraform {
  required_providers {
    aws = {
      source ="hashicorp/aws"
      version = ">=2.7.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}
terraform {
  backend  "s3" {
 key = "global/s3/terraform.tfstate"
# region = var.aws_region
 bucket = "cc-terraform-state-file"
 dynamodb_table = "terraform-state-locking"
#encrypt = true # Optional, S3 Bucket Server Side Encryption
 }
}

 resource "aws_s3_bucket" "terraform_state_s3_bucket" {
    # bucket = "${var.name}-${var.env}-terraform-state-file-storage"
      bucket = "cc-terraform-state-file"

    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = false
    }
 
   
#   server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
#        sse_algorithm     = "aws:kms"
#      }
#    }
#  }

    # tags {
    #   Name = "Terraform State File Storage"
    # }      
}

resource "aws_dynamodb_table" "terraform_state_locking_dynamodb" {
  name = "terraform-state-locking"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }

  # tags {
  #   Name = "State File Locking"
  # }
}

