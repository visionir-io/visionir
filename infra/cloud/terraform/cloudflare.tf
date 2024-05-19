data "cloudflare_ip_ranges" "cloudflare" {}

locals {
  sendgrid_records = [
    { type : "CNAME",
      name : "url694.visionir.io",
    value : "sendgrid.net" },
    { type : "CNAME",
      name : "44540979.visionir.io",
    value : "sendgrid.net" },
    { type : "CNAME",
      name : "em3164.visionir.io",
    value : "u44540979.wl230.sendgrid.net" },
    { type : "CNAME",
      name : "em7622.visionir.io",
    value : "u44540979.wl230.sendgrid.net" },
    { type : "CNAME",
      name : "s1._domainkey.visionir.io",
    value : "s1.domainkey.u44540979.wl230.sendgrid.net" },
    { type : "CNAME",
      name : "s2._domainkey.visionir.io",
    value : "s2.domainkey.u44540979.wl230.sendgrid.net" },
    { type : "TXT",
      name : "_dmarc.visionir.io",
    value : "v=DMARC1; p=none; rua=mailto:postmaster@visionir.io" },
  ]
  zoho_records = [
    { type : "TXT",
      name : "@",
    value : "zoho-verification=zb80761353.zmverify.zoho.com" },
    { type : "MX",
      name : "@",
      value : "mx.zoho.com",
    priority : 10 },
    { type : "MX",
      name : "@",
      value : "mx2.zoho.com",
    priority : 20 },
    { type : "MX",
      name : "@",
      value : "mx3.zoho.com",
      priority : 50,
    },
    { type : "TXT",
      name : "@",
    value : "v=spf1 include:zoho.com ~all" },
    {
      type : "TXT",
      name : "zmail._domainkey",
      value : var.zoho_txt_record_value
    }
  ]
}


resource "cloudflare_r2_bucket" "visionir-bucket" {
  account_id = var.cloudflare_account_id
  name       = "visionir"
  location   = "WEUR"
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zone" "visionir_io" {
  account_id = var.cloudflare_account_id
  zone       = "visionir.io"
  plan       = "free"
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
resource "cloudflare_record" "sendgrid_records" {
  for_each        = { for idx, record in local.sendgrid_records : idx => record }
  zone_id         = cloudflare_zone.visionir_io.id
  allow_overwrite = true
  name            = each.value.name
  value           = each.value.value
  type            = each.value.type
  ttl             = 1
  proxied         = false
  depends_on      = [oci_core_instance.visionir, cloudflare_zone.visionir_io]
}
resource "cloudflare_record" "zoho_records" {
  for_each        = { for idx, record in local.zoho_records : idx => record }
  zone_id         = cloudflare_zone.visionir_io.id
  allow_overwrite = true
  name            = each.value.name
  value           = each.value.value
  type            = each.value.type
  priority        = lookup(each.value, "priority", null)
  ttl             = 1
  proxied         = false
  depends_on      = [oci_core_instance.visionir, cloudflare_zone.visionir_io]
}

output "visionir_io_nameservers" {
  value     = cloudflare_zone.visionir_io.name_servers
  sensitive = true
}

output "zone_id" {
  value     = cloudflare_zone.visionir_io.id
  sensitive = true
}

output "sendgrid_records" {
  value = { for idx, record in local.sendgrid_records : idx => record.name }
}
