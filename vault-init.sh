#! /bin/sh

set -e

export VAULT_ADDR=http://vault:8200

# Wait for Vault to be ready
until wget -q -O- $VAULT_ADDR/v1/sys/health | grep '"initialized":true'; do
  echo "Waiting for Vault to be initialized..."
  sleep 2
done

# login with root token at $VAULT_ADDR
vault login root

# enable vault transit engine
vault secrets enable transit

# create key1 with type ed25519
vault write -f transit/keys/key1 type=ed25519

# create key2 with type ecdsa-p256
vault write -f transit/keys/key2 type=ecdsa-p256

# Enable kv secrets engine at kv/
vault secrets enable -path=kv kv

# Add a key-value pair secret (example: secret 'my-secret' with key 'my-key' and value 'my-value')
vault kv put kv/my-secret my-key=my-value

# Print the address to go to when started
echo "Vault is started. Access it at: http://localhost:8200"
