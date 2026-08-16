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
  xdg.configFile."noctalia/templates/fastfetch.jsonc".source = ./noctalia-templates/fastfetch.jsonc;

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    customPalettes.tincture = lib.importJSON ./noctalia-palettes/tincture.json;

    settings = {
      shell = {
        polkit_agent = true;
        clipboard_enabled = true;
        launch_apps_as_systemd_services = true;
        font_family = "Departure Mono";
      };

      bar.default.start = [
        "tanren/familiar:owl"
        "launcher"
        "wallpaper"
        "workspaces"
      ];

      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "tincture";

        templates = {
          builtin_ids = [
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

          enable_community_templates = true;
          community_ids = [
            "bat"
            "discord"
            "gimp"
            "inkscape"
            "lazygit"
            "libreoffice"
            "neovim"
            "pywalfox"
            "telegram"
            "vscode"
            "yazi"
            "zathura"
          ];

          user.fuzzel = {
            input_path = "templates/fuzzel.ini";
            output_path = "~/.config/fuzzel/noctalia.ini";
          };

          user.fastfetch = {
            input_path = "templates/fastfetch.jsonc";
            output_path = "~/.config/fastfetch/config.jsonc";
          };
        };
      };

      hooks.theme_mode_changed =
        let
          dconf = lib.getExe pkgs.dconf;
        in
        "if [ \"$NOCTALIA_THEME_MODE\" = light ]; then ${dconf} write /org/gnome/desktop/interface/icon-theme \"'Papirus-Light'\"; else ${dconf} write /org/gnome/desktop/interface/icon-theme \"'Papirus-Dark'\"; fi";

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
          "tanren/familiar"
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
            name = "familiar";
            kind = "path";
            location = "${inputs.familiar}";
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
