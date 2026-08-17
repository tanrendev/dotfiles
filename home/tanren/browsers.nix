{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    nativeMessagingHosts = [ pkgs.pywalfox-native ];
    policies.ExtensionSettings."pywalfox@frewacom.org" = {
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
    };
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
