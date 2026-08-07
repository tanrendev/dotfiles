{ pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./home-manager.nix
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
