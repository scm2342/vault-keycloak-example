resource "vault_mount" "ssh" {
  path = "ssh"
  type = "ssh"
}

resource "vault_ssh_secret_backend_ca" "ssh" {
  backend = vault_mount.ssh.path
  generate_signing_key = true
}

resource "vault_ssh_secret_backend_role" "ssh-client" {
  name = "servers"
  backend = vault_mount.ssh.path
  key_type = "ca"
  algorithm_signer = "rsa-sha2-512"
  allow_user_certificates = true
  allowed_extensions = "permit-user-rc,permit-X11-forwarding,permit-agent-forwarding,permit-pty,permit-port-forwarding"
  default_extensions = {"permit-pty": ""}
  allowed_users = "scm"
  default_user = "scm"
  ttl = "28800"
  max_ttl = "43200"
  cidr_list     = "0.0.0.0/0"
}
