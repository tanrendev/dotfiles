{ pkgs, ... }:
{
  boot = {
    plymouth = {
      enable = true;
      themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
      theme = "catppuccin-mocha";
    };

    initrd = {
      systemd.enable = true;
      verbose = false;
    };

    consoleLogLevel = 0;

    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=false"
    ];
  };
}
