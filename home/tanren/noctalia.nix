{ inputs, pkgs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  home.packages = [ pkgs.mpvpaper ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      shell = {
        polkit_agent = true;
        clipboard_enabled = true;
        launch_apps_as_systemd_services = true;
        corner_radius_scale = 0.0;
        font_family = "Departure Mono";
      };

      bar.default = {
        start = [
          "workspaces"
          "gap"
          "media"
        ];
        center = [
          "date"
          "tanren/grimoire:owl"
          "clock"
        ];
        end = [
          "tray"
          "notifications"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "session"
        ];
        radius = 0;
        thickness = 48;
      };

      widget.workspaces.style = "minimal";
      widget.gap = {
        type = "spacer";
        length = 170;
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";

        templates.builtin_ids = [
          "btop"
          "cava"
          "gtk3"
          "gtk4"
          "helix"
          "hyprland"
          "kitty"
          "qt"
          "starship"
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

      plugin_settings."noctalia/mpvpaper".video_directory = "~/Videos/Wallpapers";

      plugins = {
        enabled = [
          "noctalia/mpvpaper"
          "noctalia/screen_recorder"
          "tanren/grimoire"
        ];
        auto_update = false;
        source = [
          {
            name = "official";
            kind = "path";
            location = "${inputs.noctalia-plugins}";
            enabled = true;
          }
          {
            name = "dotfiles";
            kind = "path";
            location = "${./noctalia-plugins}";
            enabled = true;
          }
        ];
      };
    };
  };
}
