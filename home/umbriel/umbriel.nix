{ inputs, ... }:
{
  imports = [ inputs.umbriel.homeModules.default ];

  programs.umbriel = {
    enable = true;

    settings = {
      workspaces.back_and_forth = true;

      layout = {
        mode = "dwindle";
        gap = 5;
      };

      appearance = {
        border_width = 3;
        animation_ms = 1;
        shadow.enabled = false;
      };

      output = {
        "HDMI-A-2".position = [
          0
          0
        ];
        "eDP-1".position = [
          320
          1440
        ];
      };

      input = {
        keyboard.layout = "us";
        touchpad = {
          tap = true;
          natural_scroll = true;
        };
        focus.follows_mouse = true;
        cursor = {
          theme = "grimoire-cursors";
          size = 32;
        };
      };

      window_rule = [
        {
          match.app_id = "^dev\\.noctalia\\.Noctalia$";
          default_floating = true;
          default_size = [
            1080
            920
          ];
        }
        {
          match.app_id = "thunar";
          opacity = 0.8;
        }
      ];
    };
  };
}
