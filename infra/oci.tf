module "vcn" {
  source                  = "oracle-terraform-modules/vcn/oci"
  version                 = "3.6.0"
  compartment_id          = var.oci_tenancy_id
  create_internet_gateway = true
  create_nat_gateway      = true
}

resource "oci_core_subnet" "test_subnet" {
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.oci_tenancy_id
  vcn_id         = module.vcn.vcn_id
}

resource "oci_core_security_list" "example_sl" {
  compartment_id = var.oci_tenancy_id
  vcn_id         = module.vcn.vcn_id

  ingress_security_rules {
    protocol  = "6" # TCP
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group" "example_nsg" {
  compartment_id = var.oci_tenancy_id
  vcn_id         = module.vcn.vcn_id
}

resource "oci_core_network_security_group_security_rule" "example_nsg_rule" {
  network_security_group_id = oci_core_network_security_group.example_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = "0.0.0.0/0"
  source_type               = "NETWORK_SECURITY_GROUP"
  stateless                 = false
}

module "compute-instance" {
  source                     = "oracle-terraform-modules/compute-instance/oci"
  version                    = "2.4.1"
  compartment_ocid           = var.oci_tenancy_id
  source_ocid                = var.oci_ubuntu_image_id
  assign_public_ip           = true
  block_storage_sizes_in_gbs = [50]
  ssh_public_keys            = var.oci_ssh_key_path
  subnet_ocids               = [oci_core_subnet.test_subnet.id]
  primary_vnic_nsg_ids       = [oci_core_network_security_group.example_nsg.id]
  shape                      = "VM.Standard.A1.Flex" #
}
