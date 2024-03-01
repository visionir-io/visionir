variable "cloudflare_r2_api_key" {
  description = "The API key for the Cloudflare R2 storage"
  type        = string
}

variable "cloudflare_account_id" {
  description = "The account ID for Cloudflare"
  type        = string
}

variable "oci_tenancy_ocid" {
  description = "The OCID of the tenancy"
  type        = string
}

variable "config_file_profile" {
  description = "The profile name in the OCI config file"
  type        = string
}
