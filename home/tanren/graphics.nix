{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    (aseprite.overrideAttrs (
      old:
      lib.optionalAttrs (old.version == "1.3.18.1") {
        postPatch = old.postPatch + ''
          substituteInPlace src/app/i18n/strings.h \
            --replace-fail '"fmt/core.h"' '"fmt/format.h"'
        '';
      }
    ))
    fontforge-gtk
    gimp
    inkscape
  ];
}
