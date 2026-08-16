{ pkgs, ... }:
{
  programs.librewolf.enable = true;

  home.packages = with pkgs; [
    brave
    tor-browser
    ungoogled-chromium
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
    };
  };
}
