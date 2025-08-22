terraform {
  backend "s3" {
    bucket         = "takehome-bucket-mfo-dev"  
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"                  
    encrypt        = true
    dynamodb_table = "terraform-state-lock-dev"
  }
}