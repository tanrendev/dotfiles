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

    vencord.settings = {
      useQuickCss = true;
      enabledThemes = [ "tincture.theme.css" ];
    };
  };

  home.packages = [ pkgs.telegram-desktop ];

  xdg.mimeApps.defaultApplications."x-scheme-handler/tg" = "org.telegram.desktop.desktop";
}
