{ inputs, pkgs, ... }:
let
  pixelarticons = pkgs.runCommand "pixelarticons-fonts" { } ''
    install -Dm444 -t $out/share/fonts/truetype ${inputs.noctalia-pixel-art}/fonts/Pixelarticons*.ttf
  '';
in
{
  fonts = {
    packages = with pkgs; [
      departure-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      pixelarticons
    ];

    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
