module "vcn" {
  source         = "oracle-terraform-modules/vcn/oci"
  compartment_id = var.oci_tenancy_id
}

resource "oci_core_subnet" "visioniro" {
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.oci_tenancy_id
  vcn_id         = module.vcn.vcn_id
  route_table_id = oci_core_route_table.visioniro.id
  depends_on     = [oci_core_route_table.visioniro]
}
resource "oci_core_nat_gateway" "visioniro" {
  compartment_id = var.oci_tenancy_id
  vcn_id         = module.vcn.vcn_id
  block_traffic  = false
}

resource "oci_core_internet_gateway" "visioniro" {
  compartment_id = var.oci_tenancy_id
  vcn_id         = module.vcn.vcn_id
  enabled        = true
}

resource "oci_core_route_table" "visioniro" {
  compartment_id = var.oci_tenancy_id
  vcn_id         = module.vcn.vcn_id
  route_rules {
    network_entity_id = oci_core_internet_gateway.visioniro.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_network_security_group" "visioniro" {
  compartment_id = var.oci_tenancy_id
  vcn_id         = module.vcn.vcn_id
}

resource "oci_core_network_security_group_security_rule" "ssh_inbound" {
  network_security_group_id = oci_core_network_security_group.visioniro.id
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

resource "oci_core_network_security_group_security_rule" "inbound_cloudflare_https" {
  for_each                  = toset(data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks)
  network_security_group_id = oci_core_network_security_group.visioniro.id
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

resource "oci_core_network_security_group_security_rule" "inbound_cloudflare_http" {
  for_each                  = toset(data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks)
  network_security_group_id = oci_core_network_security_group.visioniro.id
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


module "compute-instance" {
  source_type                = "IMAGE"
  source                     = "oracle-terraform-modules/compute-instance/oci"
  compartment_ocid           = var.oci_tenancy_id
  source_ocid                = var.oci_ubuntu_image_id
  assign_public_ip           = true
  block_storage_sizes_in_gbs = [50]
  ssh_public_keys            = var.oci_ssh_key
  subnet_ocids               = [oci_core_subnet.visioniro.id]
  primary_vnic_nsg_ids       = [oci_core_network_security_group.visioniro.id]
  shape                      = "VM.Standard.A1.Flex"
}

output "compute-ip-address" {
  value       = module.compute-instance.public_ip[0]
  description = "value of the public ip address of the compute instance"
}
