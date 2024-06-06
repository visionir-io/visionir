terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.33.0"
    }
    oci = {
      source = "oracle/oci"
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

provider "oci" {
  tenancy_ocid        = var.oci_tenancy_id
  config_file_profile = var.config_file_profile
}

provider "sendgrid" {
  api_key = var.sendgrid_api_key
}
