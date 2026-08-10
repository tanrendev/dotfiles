{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aseprite
    fontforge
    gimp
    inkscape
  ];
}
