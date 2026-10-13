{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnome-calculator
    gnome-disk-utility
    libreoffice-fresh
    obsidian
    standardnotes
  ];
}
