#!/usr/bin/env bash
set -euo pipefail

for entry in /boot/loader/entries/*.conf; do
  read -ra options <<< "$(sed -n 's/^options[[:space:]]\+//p' "$entry")"
  params=("$@")
  for word in "${options[@]}"; do
    if [[ $word == cryptdevice=* ]]; then
      IFS=: read -r device name _ <<< "${word#cryptdevice=}"
      params+=("rd.luks.name=$(blkid -s UUID -o value "$(findfs "$device")")=$name")
    fi
  done
  for param in "${params[@]}"; do
    [[ " ${options[*]} " == *" $param "* ]] || options+=("$param")
  done
  sed -i "s|^options[[:space:]].*|options ${options[*]}|" "$entry"
done
