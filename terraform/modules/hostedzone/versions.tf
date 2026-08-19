terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    vercel = {
      source  = "vercel/vercel"
      version = ">= 4.8"
    }
  }
}

provider "vercel" {
  # .tfkeep, so it looks for api_token in term
}
