{ lib, pkgs, ... }:
{
  programs = {
    mpv = {
      enable = true;

      scripts = with pkgs.mpvScripts; [
        mpris
        thumbfast
        uosc
      ];

      config = {
        osc = false;
        hwdec = "auto-safe";
      };
    };

    swayimg.enable = true;
  };

  home.packages = [ pkgs.vlc ];

  xdg.mimeApps.defaultApplications =
    lib.genAttrs [
      "audio/aac"
      "audio/flac"
      "audio/mp4"
      "audio/mpeg"
      "audio/ogg"
      "audio/opus"
      "audio/x-wav"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/quicktime"
      "video/webm"
      "video/x-matroska"
      "video/x-msvideo"
    ] (_: "mpv.desktop")
    // lib.genAttrs [
      "image/avif"
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/svg+xml"
      "image/tiff"
      "image/webp"
    ] (_: "swayimg.desktop");
}
