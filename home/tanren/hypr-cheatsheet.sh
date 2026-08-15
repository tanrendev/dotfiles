list=$(hyprctl -j binds | jq -r '
  def bit($n): ((.modmask / $n) | floor) % 2 == 1;
  def pretty:
    {
      "mouse:272": "LEFT MOUSE",
      "mouse:273": "RIGHT MOUSE",
      "mouse:274": "MIDDLE MOUSE",
      "mouse_up": "SCROLL UP",
      "mouse_down": "SCROLL DOWN",
      "bracketleft": "[",
      "bracketright": "]",
      "comma": ",",
      "period": ".",
      "grave": "`",
      "equal": "=",
      "minus": "-",
      "slash": "/",
      "Return": "ENTER",
      "Escape": "ESC",
      "Print": "PRTSC",
      "XF86AudioRaiseVolume": "VOLUME UP",
      "XF86AudioLowerVolume": "VOLUME DOWN",
      "XF86AudioMute": "MUTE",
      "XF86AudioMicMute": "MIC MUTE",
      "XF86MonBrightnessUp": "BRIGHTNESS UP",
      "XF86MonBrightnessDown": "BRIGHTNESS DOWN",
      "XF86AudioPlay": "PLAY",
      "XF86AudioNext": "NEXT TRACK",
      "XF86AudioPrev": "PREV TRACK"
    }[.] // .;
  .[]
  | select(.description != "")
  | [
      ([
        (if bit(64) then "SUPER" else empty end),
        (if bit(4) then "CTRL" else empty end),
        (if bit(8) then "ALT" else empty end),
        (if bit(1) then "SHIFT" else empty end),
        (.key | pretty)
      ] | join(" + ")),
      .description
    ]
  | @tsv
' | column -t -s "$(printf '\t')")
fuzzel --dmenu --prompt "keys  " <<<"$list" >/dev/null || true
