resource "sendgrid_domain_authentication" "visionir_io" {
  domain             = "visionir.io"
  is_default         = true
  automatic_security = true
}
