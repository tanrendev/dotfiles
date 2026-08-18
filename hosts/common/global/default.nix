{ pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./browsers.nix
    ./dev.nix
    ./fonts.nix
    ./greeter.nix
    ./home-manager.nix
    ./hyprland.nix
    ./locale.nix
    ./monitoring.nix
    ./network.nix
    ./nix.nix
    ./noctalia.nix
    ./plymouth.nix
    ./power.nix
    ./removable-media.nix
    ./swap.nix
    ./thunar.nix
  ];

  environment.systemPackages = with pkgs; [
    curl
    git
    wget
  ];
}
