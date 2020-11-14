resource "vault_mount" "mongo" {
  path = "db/mongo"
  type = "database"
}

resource "vault_database_secret_backend_connection" "mongo" {
  backend       = vault_mount.mongo.path
  name          = "mongo"
  allowed_roles = [vault_database_secret_backend_role.admin.name]

  mongodb {
    connection_url = "mongodb://root:foobar@localhost:27017/admin"
  }
}

resource "vault_database_secret_backend_role" "admin" {
  backend             = vault_mount.mongo.path
  name                = "admin"
  db_name             = "mongo"
  creation_statements = ["{ \"db\": \"admin\", \"roles\": [{ \"role\": \"readWrite\" }] }"]
  default_ttl="28800"
  max_ttl="43200"
}
