data "cloudflare_ip_ranges" "cloudflare" {}

resource "cloudflare_r2_bucket" "visionir-bucket" {
  account_id = var.cloudflare_account_id
  name       = "visionir"
  location   = "WEUR"
}

resource "cloudflare_zone" "visionir_io" {
  account_id = var.cloudflare_account_id
  zone       = "visionir.io"
  plan       = "free"
}

resource "cloudflare_zone_dnssec" "visionir_io" {
  zone_id = cloudflare_zone.visionir_io.id
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
}
resource "cloudflare_record" "paychecks" {
  zone_id         = cloudflare_zone.visionir_io.id
  allow_overwrite = true
  name            = "paychecks"
  value           = "@"
  type            = "CNAME"
  ttl             = 1
  proxied         = true
  depends_on      = [oci_core_instance.visionir, cloudflare_zone.visionir_io, cloudflare_record.root_domain]
}
resource "cloudflare_record" "pyroscope" {
  zone_id         = cloudflare_zone.visionir_io.id
  allow_overwrite = true
  name            = "pyroscope"
  value           = "@"
  type            = "CNAME"
  ttl             = 1
  proxied         = true
  depends_on      = [oci_core_instance.visionir, cloudflare_zone.visionir_io, cloudflare_record.root_domain]
}
resource "cloudflare_record" "alloy" {
  zone_id         = cloudflare_zone.visionir_io.id
  allow_overwrite = true
  name            = "alloy"
  value           = "@"
  type            = "CNAME"
  ttl             = 1
  proxied         = true
  depends_on      = [oci_core_instance.visionir, cloudflare_zone.visionir_io, cloudflare_record.root_domain]
}

output "visionir_io_nameservers" {
  value     = cloudflare_zone.visionir_io.name_servers
  sensitive = true
}

output "zone_id" {
  value     = cloudflare_zone.visionir_io.id
  sensitive = true
}
