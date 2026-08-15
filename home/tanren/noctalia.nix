{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];

  home.packages = [ pkgs.mpvpaper ];

  xdg.configFile."noctalia/templates/fuzzel.ini".source = ./noctalia-templates/fuzzel.ini;

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    customPalettes.grimoire = lib.importJSON ./noctalia-palettes/grimoire.json;

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
        source = "custom";
        custom_palette = "grimoire";

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

        templates.user.fuzzel = {
          input_path = "templates/fuzzel.ini";
          output_path = "~/.config/fuzzel/noctalia.ini";
        };
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
          "tanren/patina"
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
          {
            name = "patina";
            kind = "path";
            location = "${inputs.patina}";
            enabled = true;
          }
        ];
      };
    };
  };
}
