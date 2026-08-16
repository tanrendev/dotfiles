{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  themeModeHook = pkgs.writeShellApplication {
    name = "theme-mode-hook";
    runtimeInputs = [ pkgs.dconf ];
    text = builtins.readFile ./theme-mode-hook.sh;
  };
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  home.packages = [ pkgs.mpvpaper ];

  xdg.configFile = {
    "noctalia/templates/fuzzel.ini".source = ./templates/fuzzel.ini;
    "noctalia/templates/fastfetch.jsonc".source = ./templates/fastfetch.jsonc;
    "noctalia/templates/vscode-dark.json".source = ./templates/vscode-dark.json;
    "noctalia/templates/vscode-light.json".source = ./templates/vscode-light.json;
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    customPalettes.tincture = lib.importJSON ./palettes/tincture.json;

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
            "discord"
            "gimp"
            "inkscape"
            "lazygit"
            "libreoffice"
            "neovim"
            "pywalfox"
            "telegram"
            "yazi"
            "zathura"
            "bat"
          ];

          user = {
            fuzzel = {
              input_path = "templates/fuzzel.ini";
              output_path = "~/.config/fuzzel/noctalia.ini";
            };

            fastfetch = {
              input_path = "templates/fastfetch.jsonc";
              output_path = "~/.config/fastfetch/config.jsonc";
            };

            vscode-dark = {
              input_path = "templates/vscode-dark.json";
              output_path = "~/.vscode/extensions/tincture-theme/themes/tincture-dark-color-theme.json";
            };

            vscode-light = {
              input_path = "templates/vscode-light.json";
              output_path = "~/.vscode/extensions/tincture-theme/themes/tincture-light-color-theme.json";
            };

          };
        };
      };

      hooks.theme_mode_changed = lib.getExe themeModeHook;

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
            name = "tanren";
            kind = "path";
            location = "${inputs.familiar}";
            enabled = true;
          }
          {
            name = "tanren";
            kind = "path";
            location = "${inputs.patina}";
            enabled = true;
          }
        ];
      };
    };
  };
}
