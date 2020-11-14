resource "keycloak_realm" "vault" {
  realm             = "vault"
  enabled           = true
  display_name      = "Vault"
  display_name_html = "<b>Vault</b>"
  login_theme = "base"

  ssl_required    = "none"
  #password_policy = "upperCase(1) and length(8) and forceExpiredPasswordChange(365) and notUsername"

  internationalization {
    supported_locales = [
      "en",
      "de"
    ]
    default_locale    = "en"
  }

  security_defenses {
    headers {
      x_frame_options                     = "DENY"
      content_security_policy             = "frame-src 'self'; frame-ancestors 'self'; object-src 'none';"
      content_security_policy_report_only = ""
      x_content_type_options              = "nosniff"
      x_robots_tag                        = "none"
      x_xss_protection                    = "1; mode=block"
      strict_transport_security           = "max-age=31536000; includeSubDomains"
    }
    brute_force_detection {
      permanent_lockout                 = false
      max_login_failures                = 30
      wait_increment_seconds            = 60
      quick_login_check_milli_seconds   = 1000
      minimum_quick_login_wait_seconds  = 60
      max_failure_wait_seconds          = 900
      failure_reset_time_seconds        = 43200
    }
  }

  #web_authn_policy {
  #  relying_party_entity_name = "Vault"
  #  relying_party_id          = "localhost"
  #  signature_algorithms      = ["ES256", "RS256"]
  #}
}

resource "keycloak_openid_client" "openid_client_vault" {
  realm_id            = keycloak_realm.vault.id
  client_id           = "vault-client"

  name                = "Vault Client"
  enabled             = true

  standard_flow_enabled = true

  access_type         = "CONFIDENTIAL"
  valid_redirect_uris = [
    "http://localhost:8250/oidc/callback",
    "http://localhost:8200/ui/vault/auth/none/oidc/callback",
    "https://oidcdebugger.com/debug"
  ]

  login_theme = "keycloak"
}

resource "keycloak_openid_user_client_role_protocol_mapper" "vault_scope_mapper" {
  realm_id   = keycloak_realm.vault.id
  client_id  = keycloak_openid_client.openid_client_vault.id
  name       = "vault_roles"
  claim_name = "vault_roles"
  multivalued = true
}

resource "keycloak_role" "vault_admin" {
  realm_id    = keycloak_realm.vault.id
  client_id   = keycloak_openid_client.openid_client_vault.id
  name        = "admin"
  description = "vault admin"
}
