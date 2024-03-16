terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    oci = {
      source = "oracle/oci"
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
