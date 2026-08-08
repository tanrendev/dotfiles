{
  imports = [
    ./hardware.nix
    ../common/global
    ../common/optional/intel-media.nix
    ../common/optional/thinkpad.nix
    ../common/users/tanren.nix
  ];

  networking.hostName = "lyngen";

  system.stateVersion = "26.05";
}
