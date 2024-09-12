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
    IdentityFile ${var.oci_ssh_key_path}
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
    hosts:
      oci:
        ansible_host: ${oci_core_instance.visionir.public_ip}
        ansible_user: ubuntu
        ansible_ssh_private_key_file: ${var.oci_ssh_key}
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
  filename = "${var.home_absolute_path}/.cloudflare/cert-key.pem"
  lifecycle {
    create_before_destroy = true
  }
  content    = tls_private_key.cert_private_key.private_key_pem
  depends_on = [cloudflare_origin_ca_certificate.visionir_io]
}
