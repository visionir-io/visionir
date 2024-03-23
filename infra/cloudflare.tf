data "cloudflare_ip_ranges" "cloudflare" {}

resource "cloudflare_account" "visionir" {
  name              = "visionir"
  enforce_twofactor = false
}

resource "cloudflare_r2_bucket" "vizionir-bucket" {
  account_id = var.cloudflare_account_id
  name       = "vizionir"
  location   = "WEUR"
}

resource "cloudflare_zone" "vizionir_com" {
  account_id = var.cloudflare_account_id
  zone       = "vizionir.com"
  plan       = "free"
}

resource "cloudflare_zone_dnssec" "vizionir_com" {
  zone_id = cloudflare_zone.vizionir_com.id
}

resource "cloudflare_record" "root_domain" {
  zone_id         = cloudflare_zone.vizionir_com.id
  allow_overwrite = true
  name            = "@"
  value           = oci_core_instance.vizionir.public_ip
  type            = "A"
  ttl             = 1
  proxied         = true
  depends_on      = [oci_core_instance.vizionir, cloudflare_zone.vizionir_com]
}

output "visionir_com_nameservers" {
  value = cloudflare_zone.vizionir_com.name_servers
}

output "cloudflare-ipv4-ranges" {
  value = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
}
