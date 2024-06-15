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
      source = "oracle/oci"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    sendgrid = {
      source  = "indentinc/sendgrid"
      version = "1.0.1"
    }
  }
}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

provider "oci" {
  tenancy_ocid        = var.oci_tenancy_id
  config_file_profile = var.config_file_profile
}

provider "sendgrid" {
  api_key = var.sendgrid_api_key
}
