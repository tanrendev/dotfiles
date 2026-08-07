{ pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./swap.nix
  ];

  environment.systemPackages = with pkgs; [
    curl
    git
    wget
  ];
}
