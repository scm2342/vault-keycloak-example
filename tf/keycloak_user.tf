resource "keycloak_user" "scm" {
  realm_id   = keycloak_realm.vault.id
  username   = "scm"
  enabled    = true

  email      = "sven@sven.cc"
  first_name = "Sven"
  last_name  = "Mattsen"

  #attributes = {
  #  foo = "bar"
  #}

  initial_password {
    value     = "foobar"
    temporary = false
  }
}

resource "keycloak_user_roles" "scm_roles" {
  realm_id = keycloak_realm.vault.id
  user_id  = keycloak_user.scm.id

  role_ids = [
    keycloak_role.vault_admin.id
  ]
}
