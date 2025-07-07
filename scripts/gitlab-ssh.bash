#!/bin/bash

echo -e "\033[1;33m===>\033[0m Przygotowanie kluczy SSH"

if [[ -z "$GITLAB_SSH_KEY" ]]; then
  echo "⚠️ GITLAB_SSH_KEY nie jest ustawione, spróbuje pobrać"
  if [[ -z "$VAULT_ADDR" ]]; then
    echo "❌ Błąd: VAULT_ADDR nie jest ustawione"
    exit 1
  fi
  if [[ -z "$VAULT_TOKEN" ]]; then
    echo "❌ Błąd: VAULT_TOKEN nie jest ustawione"
    exit 1
  fi
  
  export GITLAB_SSH_KEY=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/kv-gitlab/data/pl.rachuna-net/auth/gitlab | jq -r .data.data.GITLAB_SSH_KEY)
  echo "🔑 Pobrano klucz SSH z Vaulta"
fi

mkdir -p /home/user_vault/.ssh
chmod 700 /home/user_vault/.ssh
echo "$GITLAB_SSH_KEY" > /home/user_vault/.ssh/id_rsa
chmod 600 /home/user_vault/.ssh/id_rsa

echo "Host gitlab.com IdentityFile /home/user_vault/.ssh/id_rsa StrictHostKeyChecking no" > /home/user_vault/.ssh/config
ssh-keyscan gitlab.com >> ~/.ssh/known_hosts

echo "✅ Klucze SSH zostały pomyślnie skonfigurowane."