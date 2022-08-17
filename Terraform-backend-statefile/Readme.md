## Terraform apply first time, will say s3 not exit. 
## Apply second time, build up s3 and save statefile in s3 .
##  Put below cod in every folder which want save statefile in s3, in different path

```terraform {
  backend "s3" {
    key            = "${var.statefilepath}"     #"uat/frontend/terraform.tfstate"
    region         = "ap-southeast-2"
    bucket         = "cc-terraform-state-file"
    dynamodb_table = "terraform-state-locking"
    #encrypt = true # Optional, S3 Bucket Server Side Encryption
  }
}```