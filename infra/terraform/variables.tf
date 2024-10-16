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

variable "oci_tenancy_id" {
  # compartment_id
  description = "The OCID of the tenancy"
  type        = string
}
variable "oci_maximum_storage_size" {
  description = "The maximum storage size for the volume"
  type        = number
  default     = 150
}

variable "config_file_profile" {
  # seems not to be used
  description = "The profile name in the OCI config file"
  type        = string
}

variable "oci_namespace" {
  description = "The namespace for the OCI"
  type        = string

}

variable "oci_ubuntu_image_id" {
  description = "The OCID of the Ubuntu image"
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

variable "github_token" {
  description = "The token for Github"
  type        = string
}

variable "docker_token" {
  description = "The token for Docker"
  type        = string
}

variable "docker_user" {
  description = "The user for Docker"
  type        = string
}

variable "pypi_token" {
  description = "The user for Docker"
  type        = string
}
