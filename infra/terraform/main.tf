terraform {

  backend "s3" {
    bucket         = "visionir-tf-state"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.33.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "6.13.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    github = {
      source  = "integrations/github"
      version = "6.2.2"
    }
  }
}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "oci" {
  tenancy_ocid        = var.oci_tenancy_id
  config_file_profile = var.config_file_profile
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

provider "github" {
  token = var.github_token
}
