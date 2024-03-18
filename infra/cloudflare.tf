resource "cloudflare_r2_bucket" "visionir-bucket" {
  account_id = var.cloudflare_account_id
  name       = "visionir"
  location   = "WEUR"
}

resource "cloudflare_record" "root_domain" {
  zone_id         = var.cloudflare_zone_id
  allow_overwrite = true
  name            = "@"
  value           = module.compute-instance.public_ip[0]
  type            = "A"
  ttl             = 1
  proxied         = true
  depends_on      = [module.compute-instance]
}

resource "cloudflare_record" "paychecks_domain" {
  zone_id         = var.cloudflare_zone_id
  allow_overwrite = true
  name            = "paychecks"
  value           = module.compute-instance.public_ip[0]
  type            = "A"
  ttl             = 1
  proxied         = true
  depends_on      = [module.compute-instance]
}

data "cloudflare_ip_ranges" "cloudflare" {}

output "cloudflare-ipv4-ranges" {
  value = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
}
