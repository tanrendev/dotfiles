{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aseprite
    fontforge-gtk
    gimp
    inkscape
  ];
}
