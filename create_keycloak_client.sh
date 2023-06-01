#!/usr/bin/env bash

set -e

host=${1:-'localhost:8080'}

access_token=$(curl -s -L -X POST "http://$host/realms/master/protocol/openid-connect/token" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'username=admin' \
  --data-urlencode 'password=admin' \
  --data-urlencode 'grant_type=password' \
  --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')

user_id=$(curl -s "http://$host/admin/realms/master/users?username=admin" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $access_token" | jq -r '.[0].id')

curl -s -L -X PUT "http://$host/admin/realms/master/users/$user_id" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $access_token" \
  --data '{"email": "me@example.com", "emailVerified": true}}'

curl -s -L -X POST "http://$host/admin/realms/master/clients" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $access_token" \
  --data '{"clientId": "podinfo", "name": "podinfo", "enabled": true, "clientAuthenticatorType": "client-secret", "secret": "podinfo", "redirectUris": ["http://localhost:4180/oauth2/callback"]}'

client_id=$(curl -s "http://$host/admin/realms/master/clients?clientId=podinfo" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $access_token" | jq -r '.[0].id')

curl -s -L -X POST "http://$host/admin/realms/master/clients/$client_id/protocol-mappers/models" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $access_token" \
  --data '{"name": "aud-mapper-podinfo", "protocol": "openid-connect", "protocolMapper": "oidc-audience-mapper", "config": {"access.token.claim": "true", "id.token.claim": "true", "included.client.audience": "podinfo", "included.custom.audience": "podinfo"}}'
