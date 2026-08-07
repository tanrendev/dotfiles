{
  imports = [
    ./hardware.nix
    ../common/global
    ../common/optional/audio.nix
    ../common/optional/hyprland.nix
    ../common/optional/noctalia.nix
    ../common/users/tanren.nix
  ];

  networking.hostName = "lyngen";

  system.stateVersion = "26.05";
}
