{ config, pkgs, ... }:
let
  adwWrapper =
    variant:
    let
      base = "${pkgs.adw-gtk3}/share/themes/${variant}/gtk-3.0";
      palette = "${config.xdg.configHome}/gtk-3.0/noctalia.css";
    in
    {
      ".local/share/themes/${variant}/gtk-3.0/gtk.css".text = ''
        @import url("${base}/gtk.css");
        @import url("${palette}");
      '';
      ".local/share/themes/${variant}/gtk-3.0/gtk-dark.css".text = ''
        @import url("${base}/gtk-dark.css");
        @import url("${palette}");
      '';
    };

  papirus = pkgs.papirus-icon-theme.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + builtins.readFile ./papirus.sh;
  });
in
{
  home.packages = [ pkgs.adw-gtk3 ];

  home.file = adwWrapper "adw-gtk3" // adwWrapper "adw-gtk3-dark";

  gtk = {
    enable = true;
    gtk3.extraCss = "/* @import url(\"noctalia.css\"); */";
    iconTheme = {
      name = "Papirus-Dark";
      package = papirus;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };
}
