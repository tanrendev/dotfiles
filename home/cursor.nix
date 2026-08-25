{ pkgs, ... }:
let
  name = "grimoire-cursors";
  size = 32;
  grimoire = pkgs.callPackage ./cursors/package.nix { };
in
{
  home.pointerCursor = {
    enable = true;
    inherit name size;
    package = grimoire;
  };

  xdg.dataFile."icons/${name}".source = "${grimoire}/share/icons/${name}";
}
