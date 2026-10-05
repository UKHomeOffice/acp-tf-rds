terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.61, < 6.0"
    }
  }
  required_version = "~> 1.0"
}
