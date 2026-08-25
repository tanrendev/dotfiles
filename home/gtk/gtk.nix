{ pkgs, ... }:
let
  papirus = pkgs.papirus-icon-theme.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + builtins.readFile ./papirus.sh;
  });
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

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };
}
