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
    postInstall = (old.postInstall or "") + ''
      for theme in Papirus-Dark Papirus-Light; do
        t=$out/share/icons/$theme
        for size in "$t"/*; do
          target=$(readlink "$size" || true)
          case "$target" in
            ../Papirus/*)
              real=$out/share/icons/''${target#../}
              rm "$size"
              mkdir "$size"
              for cat in "$real"/*; do
                ln -s "$cat" "$size/''${cat##*/}"
              done
              ;;
          esac
          if [ -d "$size" ] && [ -L "$size/places" ]; then
            real=$(readlink -f "$size/places")
            rm "$size/places"
            cp -r --no-preserve=mode "$real" "$size/places"
          fi
        done
      done
      papirus-folders -t "$out/share/icons/Papirus-Dark" -o -C indigo
      papirus-folders -t "$out/share/icons/Papirus-Light" -o -C palebrown
      gtk-update-icon-cache --force "$out/share/icons/Papirus-Dark"
      gtk-update-icon-cache --force "$out/share/icons/Papirus-Light"
    '';
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
