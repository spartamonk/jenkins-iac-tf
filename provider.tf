provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::058264383077:role/aws-jenkins"
  }
  default_tags {
    tags = {
      Environment = terraform.workspace
      Createdby   = "terraform"
    }
  }
}