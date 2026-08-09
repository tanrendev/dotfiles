{ pkgs, ... }:
let
  papirus = pkgs.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "mauve";
  };
in
{
  home.packages = [ pkgs.adw-gtk3 ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = papirus;
    };
  };
}
