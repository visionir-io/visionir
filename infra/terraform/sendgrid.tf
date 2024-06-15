resource "sendgrid_domain_authentication" "visionir_io" {
  domain             = "visionir.io"
  ips                = [oci_core_instance.visionir.public_ip]
  is_default         = true
  automatic_security = true
}
