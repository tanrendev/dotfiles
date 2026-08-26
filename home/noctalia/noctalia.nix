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

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      shell = {
        polkit_agent = true;
        clipboard_enabled = true;
        launch_apps_as_systemd_services = true;
        font_family = "Departure Mono";
        greeter_sync = {
          auto_sync = true;
          privilege_command = "/run/wrappers/bin/pkexec";
        };
      };

      bar.default.start = [
        "tanren/familiar:owl"
        "launcher"
        "wallpaper"
        "workspaces"
      ];

      theme = {
        mode = "dark";
        wallpaper_scheme = "m3-content";
        templates.builtin_ids = [
          "btop"
          "cava"
          "gtk3"
          "gtk4"
          "kcolorscheme"
          "kitty"
          "qt"
          "starship"
        ];
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
      plugin_settings."tanren/patina" = {
        dark = lib.mkDefault "~/Pictures/Wallpapers/dark.png";
        light = lib.mkDefault "~/Pictures/Wallpapers/light.jpg";
      };
      wallpaper.default.path = lib.mkDefault "~/Pictures/Wallpapers/dark.png";

      plugins = {
        enabled = [
          "noctalia/kaomoji"
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
