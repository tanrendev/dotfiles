{
  imports = [
    ./hardware.nix
    ../common/global
    ../common/users/tanren.nix
  ];

  networking.hostName = "lyngen";

  system.stateVersion = "26.05";
}
