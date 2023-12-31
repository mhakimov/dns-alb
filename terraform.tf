terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.13.1"
    }
  }
  required_version = ">=0.14.9"

  backend "s3" {
       bucket = "dns-alb-remote-state"
       key    = "prod/terraform.tfstate"
       region = "eu-west-2"
   }
}

provider "aws" {
  region = var.aws_region
}
