terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Remote state — stores tfstate in S3
  backend "s3" {
    bucket = "retailrec-terraform-state"
    key    = "week2/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region  = var.region
  profile = "retailrec"
}