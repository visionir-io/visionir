resource "local_file" "ssh_config" {
  filename = "${var.home_absolute_path}/.ssh/config"
  lifecycle {
    create_before_destroy = true
  }
  content    = <<EOF
  Host oci-machine
    HostName ${oci_core_instance.visionir.public_ip}
    User ubuntu
    Port 22
    IdentityFile ${local_file.oci_machine_key.filename}
    ForwardX11 yes
    AddKeysToAgent yes
    UseKeychain yes
    ServerAliveInterval 240

  Host networkadmin
    HostName 10.0.0.254
    User nir
    Port 22
    IdentityFile ${local_file.network_admin_key.filename}
    ForwardX11 yes
    AddKeysToAgent yes
    UseKeychain yes
    ServerAliveInterval 240
    EOF
  depends_on = [oci_core_instance.visionir]
}

resource "local_file" "ansible_inventory" {
  filename = "${var.home_absolute_path}/.ansible/hosts"
  lifecycle {
    create_before_destroy = true
  }
  content    = <<EOF
  all:
    children:
      linux-based:
        hosts:
          ubuntu_oci:
            ansible_host: ${oci_core_instance.visionir.public_ip}
            ansible_user: ubuntu
            ansible_ssh_private_key_file: ${local_file.oci_machine_key.filename}
          networkadmin:
            ansible_host: 10.0.0.254
            ansible_user: nir
            ansible_ssh_private_key_file: ${local_file.network_admin_key.filename}
      others:
        hosts:
          localhost:
            ansible_connection: local
  EOF
  depends_on = [oci_core_instance.visionir]
}

resource "local_file" "cloudflare_cert" {
  filename = "${var.home_absolute_path}/.cloudflare/cert.pem"
  lifecycle {
    create_before_destroy = true
  }
  content    = cloudflare_origin_ca_certificate.visionir_io.certificate
  depends_on = [cloudflare_origin_ca_certificate.visionir_io]
}

resource "local_file" "cloudflare_cert_key" {
  filename = "${var.home_absolute_path}/.cloudflare/cert.key"
  lifecycle {
    create_before_destroy = true
  }
  content    = tls_private_key.cert_private_key.private_key_pem
  depends_on = [cloudflare_origin_ca_certificate.visionir_io]
}

resource "local_file" "oci_machine_key" {
  filename        = "${var.home_absolute_path}/.ssh/oci.key"
  file_permission = 0700
  lifecycle {
    create_before_destroy = true
  }
  content    = tls_private_key.oci_machine.private_key_pem
  depends_on = [cloudflare_origin_ca_certificate.visionir_io]
}

resource "local_file" "oci_machine_pub" {
  filename        = "${var.home_absolute_path}/.ssh/oci.pub"
  file_permission = 0700
  lifecycle {
    create_before_destroy = true
  }
  content    = tls_private_key.oci_machine.public_key_openssh
  depends_on = [cloudflare_origin_ca_certificate.visionir_io]
}

resource "tls_private_key" "network_admin" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "local_file" "network_admin_key" {
  filename        = "${var.home_absolute_path}/.ssh/network_admin.key"
  file_permission = 0700
  lifecycle {
    create_before_destroy = true
  }
  content    = tls_private_key.network_admin.private_key_pem
  depends_on = [cloudflare_origin_ca_certificate.visionir_io]
}

resource "local_file" "network_admin_pub" {
  filename        = "${var.home_absolute_path}/.ssh/network_admin.pub"
  file_permission = 0700
  lifecycle {
    create_before_destroy = true
  }
  content    = tls_private_key.network_admin.public_key_openssh
  depends_on = [cloudflare_origin_ca_certificate.visionir_io]

}
