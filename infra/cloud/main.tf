terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    oci = {
      source = "oracle/oci"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

provider "cloudflare" {
  api_key = var.cloudflare_api_key
  email   = var.visionir_email
}

provider "oci" {
  tenancy_ocid        = var.oci_tenancy_id
  config_file_profile = var.config_file_profile
}
