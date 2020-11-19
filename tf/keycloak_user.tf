resource "keycloak_user" "admin" {
  realm_id   = keycloak_realm.vault.id
  username   = "admin"
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

resource "keycloak_user_roles" "admin_roles" {
  realm_id = keycloak_realm.vault.id
  user_id  = keycloak_user.admin.id

  role_ids = [
    keycloak_role.vault_admin.id
  ]
}
