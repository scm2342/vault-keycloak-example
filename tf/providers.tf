terraform {
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
      version = ">= 2.0.0"
    }
  }
}


provider "keycloak" {
    client_id     = "admin-cli"
    username      = "scm"
    password      = "foobar"
    url           = "http://localhost:8080"
}


provider "vault" {
    address = "https://localhost:8200"
    token = "s.BkMrTjNPmcOaGhdoO5jBADiP"
    skip_tls_verify = true
}
