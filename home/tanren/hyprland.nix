{ lib, pkgs, ... }:
let
  lua = lib.generators.mkLuaInline;

  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';

  msg = cmd: exec "noctalia msg ${cmd}";

  panel = name: msg "panel-toggle ${name}";

  bind = keys: dsp: {
    _args = [
      (lua ''mod .. " + ${keys}"'')
      (lua dsp)
    ];
  };

  mouseBind = keys: dsp: {
    _args = [
      (lua ''mod .. " + ${keys}"'')
      (lua dsp)
      { mouse = true; }
    ];
  };

  plainBind = keys: dsp: {
    _args = [
      keys
      (lua dsp)
    ];
  };

  lockedKey = key: cmd: {
    _args = [
      key
      (lua (exec cmd))
      { locked = true; }
    ];
  };

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
  home.packages = with pkgs; [
    hyprpicker
    playerctl
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;

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
        (bind "Return" (exec "kitty"))
        (bind "E" (exec "thunar"))
        (bind "Y" (exec "kitty -e yazi"))
        (bind "B" (exec "librewolf"))
        (bind "C" (exec "hyprpicker -a"))
        (bind "Q" "hl.dsp.window.close()")
        (bind "F" "hl.dsp.window.fullscreen()")
        (bind "V" "hl.dsp.window.float()")
        (bind "Tab" (msg "window-switcher"))
        (bind "Space" (panel "launcher"))
        (bind "S" (panel "control-center"))
        (bind "SHIFT + V" (panel "clipboard"))
        (bind "W" (panel "wallpaper"))
        (bind "Escape" (panel "session"))
        (bind "L" (msg "session lock"))
        (bind "SHIFT + Q" "hl.dsp.exit()")
        (bind "SHIFT + S" (msg "screenshot-region"))
        (bind "comma" (msg "notification-clear-active"))
        (bind "SHIFT + comma" (msg "notification-clear-history"))
        (bind "CTRL + comma" (msg "notification-dnd-toggle"))
        (bind "grave" "hl.dsp.workspace.toggle_special()")
        (bind "SHIFT + grave" ''hl.dsp.window.move({ workspace = "special" })'')
        (bind "bracketleft" ''hl.dsp.focus({ workspace = "e-1" })'')
        (bind "bracketright" ''hl.dsp.focus({ workspace = "e+1" })'')
        (bind "SHIFT + bracketleft" ''hl.dsp.window.move({ workspace = "e-1" })'')
        (bind "SHIFT + bracketright" ''hl.dsp.window.move({ workspace = "e+1" })'')
        (bind "CTRL + Tab" ''hl.dsp.focus({ workspace = "previous" })'')
        (bind "mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')
        (bind "mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
        (mouseBind "mouse:272" "hl.dsp.window.drag()")
        (mouseBind "mouse:273" "hl.dsp.window.resize()")
        (plainBind "ALT + Tab" "hl.dsp.window.cycle_next()")
        (plainBind "ALT + SHIFT + Tab" "hl.dsp.window.cycle_next({ prev = true })")
        (plainBind "Print" (msg "screenshot-fullscreen"))
      ]
      ++ map (d: bind d ''hl.dsp.focus({ direction = "${d}" })'') directions
      ++ map (d: bind "SHIFT + ${d}" ''hl.dsp.window.move({ direction = "${d}" })'') directions
      ++ workspaceBinds
      ++ [
        (lockedKey "XF86AudioRaiseVolume" "noctalia msg volume-up")
        (lockedKey "XF86AudioLowerVolume" "noctalia msg volume-down")
        (lockedKey "XF86AudioMute" "noctalia msg volume-mute")
        (lockedKey "XF86AudioMicMute" "noctalia msg mic-mute")
        (lockedKey "XF86MonBrightnessUp" "noctalia msg brightness-up")
        (lockedKey "XF86MonBrightnessDown" "noctalia msg brightness-down")
        (lockedKey "XF86AudioPlay" "playerctl play-pause")
        (lockedKey "XF86AudioNext" "playerctl next")
        (lockedKey "XF86AudioPrev" "playerctl previous")
      ];
    };
  };
}
