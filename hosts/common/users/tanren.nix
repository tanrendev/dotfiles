{ pkgs, ... }:
{
  programs.fish.enable = true;

  users.users.tanren = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  home-manager.users.tanren = import ../../../home/tanren;
}
