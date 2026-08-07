{
  imports = [
    ./browsers.nix
    ./hyprland.nix
    ./kitty.nix
    ./noctalia.nix
    ./shell.nix
  ];

  home = {
    username = "tanren";
    homeDirectory = "/home/tanren";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
