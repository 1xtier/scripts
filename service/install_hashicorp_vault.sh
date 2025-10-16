#!/bin/bash
RED='\033[31m'
NORMAL='\033[0m'
export VERSION_HASHICORP_VAULT="1.20.2"

echo "At the time of writing this script, the latest version is 1.20.2"
echo -e "Please check out the lastest version on:$RED https://hashicorp-releases.yandexcloud.net/vault$NORMAL"
function installvault() {

  wget https://hashicorp-releases.yandexcloud.net/vault/${VERSION_HASHICORP_VAULT}/vault_${VERSION_HASHICORP_VAULT}_linux_amd64.zip
  unzip vault_${VERSION_HASHICORP_VAULT}_linux_amd64.zip
  cp vault /usr/local/bin
  /usr/local/bin/vault --version
  /usr/local/bin/vault --autocomplete-install
  complete -C /usr/local/bin/vault vault
}
installvault

