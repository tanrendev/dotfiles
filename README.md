NixOS flake. Hyprland with [Noctalia](https://docs.noctalia.dev/v5/).

```
nixos-rebuild switch --flake .#lyngen
prek run --all-files
nix flake check
nix develop
```

## Credits

Inspired by [Misterio77/Foundry](https://github.com/Misterio77/Foundry), MIT,
Copyright (c) 2021 Gabriel Fontes.
