data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.oci_tenancy_id
}

resource "oci_core_vcn" "vizionir" {
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.oci_tenancy_id
  dns_label      = "vznirvcn"
  display_name   = "vizionir_vcn"
}

resource "oci_core_subnet" "vizionir" {
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.oci_tenancy_id
  vcn_id         = oci_core_vcn.vizionir.id
  route_table_id = oci_core_route_table.vizionir.id
  dns_label      = "vznirsubnet"
  depends_on     = [oci_core_route_table.vizionir]
  display_name   = "vizionir_subnet"
}

resource "oci_core_internet_gateway" "vizionir" {
  compartment_id = var.oci_tenancy_id
  vcn_id         = oci_core_vcn.vizionir.id
  enabled        = true
  display_name   = "vizionir_igw"
}

resource "oci_core_route_table" "vizionir" {
  compartment_id = var.oci_tenancy_id
  vcn_id         = oci_core_vcn.vizionir.id
  display_name   = "vizionir_rt"
  route_rules {
    network_entity_id = oci_core_internet_gateway.vizionir.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_network_security_group" "vizionir" {
  compartment_id = var.oci_tenancy_id
  vcn_id         = oci_core_vcn.vizionir.id
  display_name   = "vizionir_nsg"
}

resource "oci_core_network_security_group_security_rule" "ssh_inbound" {
  description               = "Allow SSH from home"
  network_security_group_id = oci_core_network_security_group.vizionir.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.home_public_ip
  stateless                 = false
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "outbound_https" {
  description               = "Allow HTTPS traffic to the internet"
  network_security_group_id = oci_core_network_security_group.vizionir.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  stateless                 = false
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "outbound_http" {
  description               = "Allow HTTP traffic to the internet"
  network_security_group_id = oci_core_network_security_group.vizionir.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  stateless                 = false
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "inbound_cloudflare_http" {
  description               = "Allow HTTP traffic from Cloudflare"
  for_each                  = toset(data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks)
  network_security_group_id = oci_core_network_security_group.vizionir.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = each.value
  stateless                 = false
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}
resource "oci_core_network_security_group_security_rule" "inbound_cloudflare_https" {
  description               = "Allow HTTPS traffic from Cloudflare"
  for_each                  = toset(data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks)
  network_security_group_id = oci_core_network_security_group.vizionir.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = each.value
  stateless                 = false
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_instance" "vizionir" {
  display_name        = "vizionir"
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  compartment_id      = var.oci_tenancy_id
  shape               = "VM.Standard.A1.Flex"
  create_vnic_details {
    assign_public_ip          = true
    assign_private_dns_record = true
    nsg_ids                   = [oci_core_network_security_group.vizionir.id]
    subnet_id                 = oci_core_subnet.vizionir.id
  }
  metadata = {
    "ssh_authorized_keys" = var.oci_ssh_key
  }
  source_details {
    source_type = "image"
    source_id   = var.oci_ubuntu_image_id
  }
  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }
}

output "compute-ip-address" {
  value       = oci_core_instance.vizionir.public_ip
  description = "value of the public ip address of the compute instance"
}
