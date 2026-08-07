{
  users.users.tanren = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  home-manager.users.tanren = import ../../../home/tanren;
}
