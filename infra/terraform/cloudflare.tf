data "cloudflare_ip_ranges" "cloudflare" {}

locals {
  auth_records = [
    #sendgrid
    { type : "CNAME",
      name : "em1682.visionir.io",
    value : "u45017358.wl109.sendgrid.net" }
    ,
    { type : "CNAME",
      name : "s1._domainkey.visionir.io",
    value : "s1.domainkey.u45017358.wl109.sendgrid.net" }
    ,
    { type : "CNAME",
      name : "s2._domainkey.visionir.io",
    value : "s2.domainkey.u45017358.wl109.sendgrid.net" }
    ,
    { type : "CNAME",
      name : "url8266.visionir.io",
    value : "sendgrid.net" }
    ,
    { type : "CNAME",
      name : "45017358.visionir.io",
    value : "sendgrid.net" }
    ,
    { type : "TXT",
      name : "_dmarc.visionir.io",
    value : "v=DMARC1; p=none; rua=mailto:postmaster@visionir.io" }
    ,
    # icloud_records
    { type : "TXT",
      name : "@",
      value : "apple-domain=3mM0Q7ibDG1aA7rn",
      ttl : 3600
    }
    ,
    { type : "TXT",
      name : "@",
      value : "v=spf1 include:icloud.com ~all",
      ttl : 3600
    }
    ,
    { type : "MX",
      name : "@",
      value : "mx01.mail.icloud.com.",
      ttl : 3600
      priority : 10
    }
    ,
    { type : "MX",
      name : "@",
      value : "mx02.mail.icloud.com.",
      ttl : 3600
      priority : 10
    }
    ,
    { type : "CNAME",
      name : "sig1._domainkey",
      value : "sig1.dkim.visionir.io.at.icloudmailadmin.com.",
      ttl : 3600
    }
    ,
    #discord_records
    { type : "TXT",
      name : "_discord.visionir.io",
      value : "dh=4d3a9ab6eabe4fc2ef6c0727356d9ec0fd3efa23"
    }
    ,
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
resource "cloudflare_record" "auth_records" {
  for_each        = { for idx, record in local.auth_records : idx => record }
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
