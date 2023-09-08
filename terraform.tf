terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
       version = "> 4.4.0"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
       bucket = "dns-alb-remote-state"
       key    = "prod/terraform.tfstate"
       region = "eu-west-2"
   }
}

provider "aws" {
  region = "eu-west-2"
}
