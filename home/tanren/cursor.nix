{ pkgs, ... }:
let
  name = "catppuccin-mocha-dark-cursors";
  size = 24;

  env = variable: value: {
    _args = [
      variable
      value
    ];
  };
in
{
  home.pointerCursor = {
    inherit name size;
    package = pkgs.catppuccin-cursors.mochaDark;
  };

  wayland.windowManager.hyprland.settings.env = [
    (env "XCURSOR_THEME" name)
    (env "XCURSOR_SIZE" (toString size))
    (env "HYPRCURSOR_THEME" name)
    (env "HYPRCURSOR_SIZE" (toString size))
  ];
}
