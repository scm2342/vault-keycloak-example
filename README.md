# Vault Keycloak example

## Steps to reproduce
1. `docker-compose up -d`
1. try login to `http://localhost:8080` with admin and foobar
1. `export VAULT_SKIP_VERIFY=1`
1. `vault operator init`
1. `vault operator unseal`
1. `vault login`
1. `cd tf && terraform init`
1. `cd tf && terraform apply`
1. `rm ~/.vault-token`
1. `vault login -method=oidc port=8250` with admin and foobar

You are now logged in to vault via keycloak

## Mongo
1. run `docker run --rm -ti --network=host mongo mongo mongodb://localhost:27017/admin`
1. run `db.foobar.insert({})` verify you don't have access
1. now run `vault read db/mongo/creds/admin`
1. verify you can use the provided credentials with `db.foobar.insert({})` on mongo like above

## SSH
1. run `vault read -field=public_key ssh/config/ca` and save to a file
1. put that file on ssh server
1. set `TrustedUserCAKeys` to that file
1. login with `vault ssh -role servers -mode ca -public-key-path pubkeyfile user@host` assuming the agent has your private key loaded