{
  imports = [
    ./browsers.nix
    ./dev.nix
    ./editors.nix
    ./hyprland.nix
    ./kitty.nix
    ./media.nix
    ./noctalia.nix
    ./removable-media.nix
    ./shell.nix
    ./xdg.nix
  ];

  home = {
    username = "tanren";
    homeDirectory = "/home/tanren";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
