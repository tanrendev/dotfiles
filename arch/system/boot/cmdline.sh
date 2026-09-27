#!/usr/bin/env bash
set -euo pipefail

conf=/boot/EFI/BOOT/limine.conf

mapfile -t lines < "$conf"
for i in "${!lines[@]}"; do
  [[ ${lines[i]} =~ ^[[:space:]]*cmdline: ]] || continue
  for param in "$@"; do
    [[ " ${lines[i]} " == *" $param "* ]] || lines[i]+=" $param"
  done
done
printf '%s\n' "${lines[@]}" > "$conf"
