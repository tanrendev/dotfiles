{
  imports = [
    ./hyprland.nix
    ./noctalia.nix
  ];

  home = {
    username = "tanren";
    homeDirectory = "/home/tanren";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
