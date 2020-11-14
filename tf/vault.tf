resource "vault_audit" "stdout" {
  type = "file"

  options = {
    file_path = "stdout"
  }
}

resource "vault_jwt_auth_backend" "keycloak" {
    description  = "Authenticate users via keycloak"
    path = "oidc"
    type = "oidc"
    default_role = "keycloak-role"
    oidc_discovery_url = "http://localhost:8080/auth/realms/vault"
    oidc_client_id = keycloak_openid_client.openid_client_vault.client_id
    oidc_client_secret = keycloak_openid_client.openid_client_vault.client_secret
    bound_issuer = "http://localhost:8080/"
    tune {
        listing_visibility = "unauth"
    }
}
resource "vault_jwt_auth_backend_role" "keycloak-role" {
  backend         = vault_jwt_auth_backend.keycloak.path
  role_name       = "keycloak-role"
  #token_policies  = ["default", "dev", "prod"]

  user_claim            = "preferred_username"
  role_type             = "oidc"
  allowed_redirect_uris = ["http://localhost:8200/ui/vault/auth/oidc/oidc/callback", "http://localhost:8250/oidc/callback"]
  claim_mappings = {
    email: "email"
    given_name: "given_name",
    family_name: "family_name"
  }
  bound_audiences = ["vault-client"]
  groups_claim = "vault_roles"
}

resource "vault_identity_group" "admin" {
  name     = "admin"
  type     = "external"
  policies = ["default"]

  #metadata = {
  #  version = "1"
  #}
}

resource "vault_identity_group_alias" "admin-oidc-alias" {
  name           = "admin"
  mount_accessor = vault_jwt_auth_backend.keycloak.accessor
  canonical_id   = vault_identity_group.admin.id
}
