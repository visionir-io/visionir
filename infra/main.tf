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
  api_token = var.cloudflare_r2_api_key
}

provider "oci" {
  tenancy_ocid        = var.oci_tenancy_ocid
  config_file_profile = var.config_file_profile
}

resource "cloudflare_r2_bucket" "visionir-bucket" {
  account_id = var.cloudflare_account_id
  name       = "visionir"
  location   = "WEUR"
}
