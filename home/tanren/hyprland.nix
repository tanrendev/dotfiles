{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;

  bind = keys: dsp: {
    _args = [
      (lua ''mod .. " + ${keys}"'')
      (lua dsp)
    ];
  };

  mediaKey = key: cmd: {
    _args = [
      key
      (lua ''hl.dsp.exec_cmd("noctalia msg ${cmd}")'')
      { locked = true; }
    ];
  };

  panel = name: ''hl.dsp.exec_cmd("noctalia msg panel-toggle ${name}")'';

  directions = [
    "left"
    "right"
    "up"
    "down"
  ];

  workspaceBinds = lib.concatMap (i: [
    (bind (toString i) "hl.dsp.focus({ workspace = ${toString i} })")
    (bind "SHIFT + ${toString i}" "hl.dsp.window.move({ workspace = ${toString i} })")
  ]) (lib.range 1 8);
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      mod = {
        _var = "SUPER";
      };

      monitor = [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "1";
        }
        {
          output = "eDP-1";
          mode = "preferred";
          position = "0x0";
          scale = "1";
        }
      ];

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 1;
          layout = "dwindle";
        };

        decoration = {
          rounding = 20;
          rounding_power = 2;
          blur = {
            enabled = true;
            size = 3;
            passes = 2;
            vibrancy = 0.1696;
          };
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            tap-to-click = true;
          };
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        animations.enabled = true;
      };

      window_rule = {
        match.class = "dev.noctalia.Noctalia";
        float = true;
        size = [
          1080
          920
        ];
      };

      layer_rule = {
        name = "noctalia";
        match.namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
        no_anim = true;
        ignore_alpha = 0.5;
        blur = true;
        blur_popups = true;
      };

      bind = [
        (bind "Return" ''hl.dsp.exec_cmd("kitty")'')
        (bind "Q" "hl.dsp.window.close()")
        (bind "F" "hl.dsp.window.fullscreen()")
        (bind "V" "hl.dsp.window.float()")
        (bind "Tab" ''hl.dsp.exec_cmd("noctalia msg window-switcher")'')
        (bind "Space" (panel "launcher"))
        (bind "S" (panel "control-center"))
        (bind "SHIFT + V" (panel "clipboard"))
        (bind "W" (panel "wallpaper"))
        (bind "Escape" (panel "session"))
        (bind "L" ''hl.dsp.exec_cmd("noctalia msg session lock")'')
        (bind "SHIFT + Q" "hl.dsp.exit()")
      ]
      ++ map (d: bind d ''hl.dsp.focus({ direction = "${d}" })'') directions
      ++ map (d: bind "SHIFT + ${d}" ''hl.dsp.window.move({ direction = "${d}" })'') directions
      ++ workspaceBinds
      ++ [
        (mediaKey "XF86AudioRaiseVolume" "volume-up")
        (mediaKey "XF86AudioLowerVolume" "volume-down")
        (mediaKey "XF86AudioMute" "volume-mute")
        (mediaKey "XF86AudioMicMute" "mic-mute")
        (mediaKey "XF86MonBrightnessUp" "brightness-up")
        (mediaKey "XF86MonBrightnessDown" "brightness-down")
      ];
    };
  };
}
