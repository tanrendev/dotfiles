{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    nativeMessagingHosts = [ pkgs.pywalfox-native ];
  };

  home.packages = with pkgs; [
    brave
    pywalfox-native
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
