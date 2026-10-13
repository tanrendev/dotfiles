{ pkgs, ... }:
{
  programs.vesktop = {
    enable = true;

    settings = {
      discordBranch = "stable";
      tray = true;
      minimizeToTray = true;
      hardwareAcceleration = true;
    };
  };

  home.packages = with pkgs; [
    signal-desktop
    telegram-desktop
  ];

  xdg.mimeApps.defaultApplications."x-scheme-handler/tg" = "org.telegram.desktop.desktop";
}
