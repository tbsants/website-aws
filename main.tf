terraform {
  required_version = ">=1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
  }

  backend "s3" {
    bucket = "projects-trfm-remote-state"
    key    = "website-infra-aws/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner     = "tbsantos"
      managedby = "terraform"
    }
  }
}

data "terraform_remote_state" "modulo-vpc" {
  backend = "s3"
  config = {
    bucket = "projects-trfm-remote-state"
    key    = "modulo-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}