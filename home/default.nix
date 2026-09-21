{
  imports = [
    ./browsers.nix
    ./chat.nix
    ./cursor.nix
    ./dev.nix
    ./editors/editors.nix
    ./fuzzel.nix
    ./graphics.nix
    ./gtk/gtk.nix
    ./umbriel/umbriel.nix
    ./kitty/kitty.nix
    ./media.nix
    ./noctalia/noctalia.nix
    ./office.nix
    ./pdf.nix
    ./removable-media.nix
    ./shell/shell.nix
    ./xdg.nix
  ];

  home = {
    username = "tanren";
    homeDirectory = "/home/tanren";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
