{ pkgs, ... }:
{
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

  environment = {
    sessionVariables.LIBVA_DRIVER_NAME = "iHD";

    systemPackages = with pkgs; [
      ffmpeg-full
      libva-utils
    ];
  };
}
