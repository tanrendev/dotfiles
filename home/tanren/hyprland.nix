{ lib, pkgs, ... }:
let
  lua = lib.generators.mkLuaInline;

  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';

  msg = cmd: exec "noctalia msg ${cmd}";

  panel = name: msg "panel-toggle ${name}";

  bind = description: keys: dsp: {
    _args = [
      (lua ''mod .. " + ${keys}"'')
      (lua dsp)
      { inherit description; }
    ];
  };

  mouseBind = description: keys: dsp: {
    _args = [
      (lua ''mod .. " + ${keys}"'')
      (lua dsp)
      {
        inherit description;
        mouse = true;
      }
    ];
  };

  plainBind = description: keys: dsp: {
    _args = [
      keys
      (lua dsp)
      { inherit description; }
    ];
  };

  lockedKey = description: key: cmd: {
    _args = [
      key
      (lua (exec cmd))
      {
        inherit description;
        locked = true;
      }
    ];
  };

  directions = [
    "left"
    "right"
    "up"
    "down"
  ];

  workspaceBinds = lib.concatMap (
    i:
    let
      n = toString i;
    in
    [
      (bind "Workspace ${n}" n "hl.dsp.focus({ workspace = ${n} })")
      (bind "Move window to workspace ${n}" "SHIFT + ${n}" "hl.dsp.window.move({ workspace = ${n} })")
    ]
  ) (lib.range 1 8);

  cheatsheet = pkgs.writeShellApplication {
    name = "hypr-cheatsheet";
    runtimeInputs = with pkgs; [
      fuzzel
      jq
      util-linux
    ];
    text = builtins.readFile ./hypr-cheatsheet.sh;
  };
in
{
  home.packages = with pkgs; [
    cheatsheet
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
            tap_to_click = true;
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
        (bind "Terminal" "Return" (exec "kitty"))
        (bind "File manager" "E" (exec "thunar"))
        (bind "Yazi" "Y" (exec "kitty -e yazi"))
        (bind "Browser" "B" (exec "librewolf"))
        (bind "Colour picker" "C" (exec "hyprpicker -a"))
        (bind "Keybinds cheatsheet" "slash" (exec (lib.getExe cheatsheet)))
        (bind "Close window" "Q" "hl.dsp.window.close()")
        (bind "Fullscreen" "F" "hl.dsp.window.fullscreen()")
        (bind "Toggle floating" "V" "hl.dsp.window.float()")
        (bind "Window switcher" "Tab" (msg "window-switcher"))
        (bind "Launcher" "Space" (panel "launcher"))
        (bind "Control center" "S" (panel "control-center"))
        (bind "Clipboard history" "SHIFT + V" (panel "clipboard"))
        (bind "Wallpaper picker" "W" (panel "wallpaper"))
        (bind "Session menu" "Escape" (panel "session"))
        (bind "Lock screen" "L" (msg "session lock"))
        (bind "Exit Hyprland" "SHIFT + Q" "hl.dsp.exit()")
        (bind "Screenshot region" "SHIFT + S" (msg "screenshot-region"))
        (bind "Clear notifications" "comma" (msg "notification-clear-active"))
        (bind "Clear notification history" "SHIFT + comma" (msg "notification-clear-history"))
        (bind "Toggle do not disturb" "CTRL + comma" (msg "notification-dnd-toggle"))
        (bind "Toggle special workspace" "grave" "hl.dsp.workspace.toggle_special()")
        (bind "Move window to special workspace" "SHIFT + grave"
          ''hl.dsp.window.move({ workspace = "special" })''
        )
        (bind "Previous workspace" "bracketleft" ''hl.dsp.focus({ workspace = "e-1" })'')
        (bind "Next workspace" "bracketright" ''hl.dsp.focus({ workspace = "e+1" })'')
        (bind "Move window to previous workspace" "SHIFT + bracketleft"
          ''hl.dsp.window.move({ workspace = "e-1" })''
        )
        (bind "Move window to next workspace" "SHIFT + bracketright"
          ''hl.dsp.window.move({ workspace = "e+1" })''
        )
        (bind "Last workspace" "CTRL + Tab" ''hl.dsp.focus({ workspace = "previous" })'')
        (bind "Previous workspace" "mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')
        (bind "Next workspace" "mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
        (mouseBind "Drag window" "mouse:272" "hl.dsp.window.drag()")
        (mouseBind "Resize window" "mouse:273" "hl.dsp.window.resize()")
        (plainBind "Cycle windows" "ALT + Tab" "hl.dsp.window.cycle_next()")
        (plainBind "Cycle windows backwards" "ALT + SHIFT + Tab"
          "hl.dsp.window.cycle_next({ next = false })"
        )
        (plainBind "Screenshot screen" "Print" (msg "screenshot-fullscreen"))
      ]
      ++ map (d: bind "Focus ${d}" d ''hl.dsp.focus({ direction = "${d}" })'') directions
      ++ map (
        d: bind "Move window ${d}" "SHIFT + ${d}" ''hl.dsp.window.move({ direction = "${d}" })''
      ) directions
      ++ workspaceBinds
      ++ [
        (lockedKey "Volume up" "XF86AudioRaiseVolume" "noctalia msg volume-up")
        (lockedKey "Volume down" "XF86AudioLowerVolume" "noctalia msg volume-down")
        (lockedKey "Mute" "XF86AudioMute" "noctalia msg volume-mute")
        (lockedKey "Mute microphone" "XF86AudioMicMute" "noctalia msg mic-mute")
        (lockedKey "Brightness up" "XF86MonBrightnessUp" "noctalia msg brightness-up")
        (lockedKey "Brightness down" "XF86MonBrightnessDown" "noctalia msg brightness-down")
        (lockedKey "Play or pause" "XF86AudioPlay" "playerctl play-pause")
        (lockedKey "Next track" "XF86AudioNext" "playerctl next")
        (lockedKey "Previous track" "XF86AudioPrev" "playerctl previous")
      ];
    };
  };
}
