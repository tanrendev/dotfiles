{ pkgs, ... }:
let
  xname = "catppuccin-mocha-dark-cursors";
  xsize = 24;
  name = "grimoire-cursors";
  size = 32;
  grimoire = pkgs.callPackage ./cursors/package.nix { };

  env = variable: value: {
    _args = [
      variable
      value
    ];
  };
in
{
  home.pointerCursor = {
    enable = true;
    name = xname;
    size = xsize;
    package = pkgs.catppuccin-cursors.mochaDark;
  };

  xdg.dataFile."icons/${name}".source = "${grimoire}/share/icons/${name}";

  wayland.windowManager.hyprland.settings.env = [
    (env "XCURSOR_THEME" xname)
    (env "XCURSOR_SIZE" (toString xsize))
    (env "HYPRCURSOR_THEME" name)
    (env "HYPRCURSOR_SIZE" (toString size))
  ];
}
