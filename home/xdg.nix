{
  config,
  lib,
  pkgs,
  ...
}:
let
  wallpapers = pkgs.runCommand "wallpapers-fallback" { } ''
    mkdir $out
    ln -st $out ${
      lib.concatMapStringsSep " " (w: "${w}/share/backgrounds/nixos/*.png") (
        with pkgs.nixos-artwork.wallpapers;
        [
          gradient-grey
          moonscape
          nineish-dark-gray
          waterfall
        ]
      )
    }
  '';
in
{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      projects = "${config.home.homeDirectory}/Workshop";
    };

    mimeApps.defaultApplications."inode/directory" = "thunar.desktop";
  };

  home.file."Pictures/Wallpapers" = {
    source = wallpapers;
    recursive = true;
  };
  home.file."Videos/Wallpapers/.keep".text = "";
}
