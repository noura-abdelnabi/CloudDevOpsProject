terraform {
  backend "s3" {
    bucket         = "finalproject-terraformstate-bucket"
    key            = "devops-project/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}