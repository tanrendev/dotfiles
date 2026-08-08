{ pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./dev.nix
    ./fonts.nix
    ./greeter.nix
    ./home-manager.nix
    ./hyprland.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./noctalia.nix
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
