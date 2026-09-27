#!/usr/bin/env bash
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"

if ! pacman -Q decman > /dev/null 2>&1; then
  build="$(mktemp -d)"
  git clone https://aur.archlinux.org/decman.git "$build"
  (cd "$build" && makepkg -si)
  rm -rf "$build"
fi

sudo decman --source "$here/source.py"
