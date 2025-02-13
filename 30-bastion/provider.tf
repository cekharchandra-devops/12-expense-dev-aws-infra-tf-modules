terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
  backend "s3" {
    bucket         = "expense-vpc-module"
    key            = "expense-dev-bastion"
    region         = "us-east-1"
    dynamodb_table = "vpc-expense-dev"
  }
}
provider "aws" {
  region = "us-east-1"
}