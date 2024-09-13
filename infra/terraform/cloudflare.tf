data "cloudflare_ip_ranges" "cloudflare" {}


resource "cloudflare_account" "visionir" {
  name = "visionir.io"
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zone" "visionir_io" {
  account_id = cloudflare_account.visionir.id
  zone       = "visionir.io"
  plan       = "free"
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_r2_bucket" "visionir-bucket" {
  account_id = cloudflare_account.visionir.id
  name       = "visionir"
  location   = "WEUR"
  lifecycle {
    prevent_destroy = true
  }
}


resource "cloudflare_zone_dnssec" "visionir_io" {
  zone_id = cloudflare_zone.visionir_io.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "req" {
  private_key_pem = tls_private_key.cert_private_key.private_key_pem
  dns_names       = ["*.${var.visionir_domain}", "${var.visionir_domain}"]

  subject {
    common_name = "*.${var.visionir_domain}"
  }
}

resource "cloudflare_origin_ca_certificate" "visionir_io" {
  csr                = tls_cert_request.req.cert_request_pem
  hostnames          = tls_cert_request.req.dns_names
  request_type       = "origin-rsa"
  requested_validity = 5475
  depends_on         = [tls_cert_request.req]
}

resource "cloudflare_record" "root_domain" {
  zone_id         = cloudflare_zone.visionir_io.id
  allow_overwrite = true
  name            = "@"
  value           = oci_core_instance.visionir.public_ip
  type            = "A"
  ttl             = 1
  proxied         = true
  depends_on      = [oci_core_instance.visionir, cloudflare_zone.visionir_io]
  lifecycle {
    prevent_destroy = true
  }
}
resource "cloudflare_record" "subdomain" {
  zone_id         = cloudflare_zone.visionir_io.id
  allow_overwrite = true
  name            = "*"
  value           = oci_core_instance.visionir.public_ip
  type            = "A"
  ttl             = 1
  proxied         = true
  depends_on      = [oci_core_instance.visionir, cloudflare_zone.visionir_io]
  lifecycle {
    prevent_destroy = true
  }
}

output "visionir_io_nameservers" {
  value     = cloudflare_zone.visionir_io.name_servers
  sensitive = true
}

output "zone_id" {
  value     = cloudflare_zone.visionir_io.id
  sensitive = true
}

output "ca_cert" {
  value = cloudflare_origin_ca_certificate.visionir_io.certificate
}
