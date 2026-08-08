{ inputs, pkgs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  home.packages = with pkgs; [
    adw-gtk3
    mpvpaper
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      shell = {
        polkit_agent = true;
        clipboard_enabled = true;
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";

        templates.builtin_ids = [
          "gtk3"
          "gtk4"
        ];
      };

      location.auto_locate = true;

      weather = {
        enabled = true;
        unit = "celsius";
      };

      idle.behavior = {
        lock = {
          enabled = true;
          timeout = 600;
          action = "lock";
        };
        screen-off = {
          enabled = true;
          timeout = 660;
          action = "screen_off";
        };
      };

      plugins = {
        enabled = [
          "noctalia/mpvpaper"
          "noctalia/screen_recorder"
          "noctalia/wallhaven"
        ];
        auto_update = false;
        source = [
          {
            name = "official";
            kind = "path";
            location = "${inputs.noctalia-plugins}";
            enabled = true;
          }
        ];
      };
    };
  };
}
