#!/bin/sh

PROXMOX_PROVIDER=$(curl  --silent https://api.github.com/repos/Telmate/terraform-provider-proxmox/releases | jq -r '.[0].name' | tr -d "v")
KERNEL=$(uname -s)
ARH=$(uname -m)

if [ $KERNEL = "Linux" ]; then
  KERNEL="linux"
elif [ $KERNEL = "Darwin" ]; then
  KERNEL="darwin"
else 
  echo "There is no such version"
fi 
if [ ${ARH} = "x86_64" ]; then 
	ARH_VERSION="amd64"
elif [ ${ARH} = "arm64" ]; then
	ARH_VERSION="arm64"
else
 echo "There is no such version"
fi

echo "terraform-provider-proxmox_$(sed -n 's/-.*$//p' <<< ${PROXMOX_PROVIDER})_${KERNEL}_${ARH_VERSION}.zip"

mkdir -p $HOME/.terraform.d/plugins/registry.terraform.io/telmate/proxmox/$(sed -n 's/-.*$//p' <<< ${PROXMOX_PROVIDER})/${KERNEL}_${ARH_VERSION}/ 
wget https://github.com/Telmate/terraform-provider-proxmox/releases/download/v${PROXMOX_PROVIDER}/terraform-provider-proxmox_${PROXMOX_PROVIDER}_${KERNEL}_${ARH_VERSION}.zip
unzip -j "terraform-provider-proxmox_${PROXMOX_PROVIDER}_${KERNEL}_${ARH_VERSION}.zip" "terraform-provider-proxmox_v${PROXMOX_PROVIDER}" -d "$HOME/.terraform.d/plugins/registry.terraform.io/telmate/proxmox/$(sed -n 's/-.*$//p' <<< ${PROXMOX_PROVIDER})/${KERNEL}_${ARH_VERSION}/" 
