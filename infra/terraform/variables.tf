variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "aws_access_key_id" {
  description = "The AWS access key"
  type        = string
}

variable "aws_secret_access_key" {
  description = "The AWS secret key"
  type        = string
}

variable "aws_tf_state_policy_name" {
  description = "The name of the policy for Terraform state"
  type        = string
  default     = "TerraformStatePolicy"
}

variable "cloudflare_api_token" {
  description = "The API key for the Cloudflare Zone API"
  type        = string
}

variable "cloudflare_account_id" {
  description = "The account ID for Cloudflare"
  type        = string
}

variable "oci_tenancy_id" {
  description = "The OCID of the tenancy"
  type        = string
}
variable "oci_maximum_storage_size" {
  description = "The maximum storage size for the volume"
  type        = number
  default     = 200
}

variable "config_file_profile" {
  description = "The profile name in the OCI config file"
  type        = string
}

variable "oci_ubuntu_image_id" {
  description = "The OCID of the Ubuntu image"
  type        = string
}

variable "oci_ssh_key" {
  description = "The SSH public key"
  type        = string

}
variable "oci_ssh_key_path" {
  description = "The SSH public key path"
  type        = string

}

variable "visionir_domain" {
  description = "The domain name for visionir"
  type        = string

}
variable "visionir_email" {
  description = "The email name for visionir"
  type        = string

}
variable "home_absolute_path" {
  description = "Absolute path to the home directory"
  type        = string

}

variable "sendgrid_api_key" {
  description = "The API key for Sendgrid"
  type        = string
}
