{ pkgs, ... }:
let
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
    inherit name size;
    package = grimoire;
  };

  xdg.dataFile."icons/${name}".source = "${grimoire}/share/icons/${name}";

  wayland.windowManager.hyprland.settings.env = [
    (env "XCURSOR_THEME" name)
    (env "XCURSOR_SIZE" (toString size))
    (env "HYPRCURSOR_THEME" name)
    (env "HYPRCURSOR_SIZE" (toString size))
  ];
}
