{ pkgs, ... }:
{
  programs.fish.enable = true;

  users.users.tanren = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
  };

  home-manager.users.tanren = import ../../../home/tanren;
}
