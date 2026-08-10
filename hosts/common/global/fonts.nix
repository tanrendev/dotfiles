{ lib, pkgs, ... }:
{
  fonts = {
    packages =
      with pkgs;
      [
        departure-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ]
      ++ builtins.filter lib.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
