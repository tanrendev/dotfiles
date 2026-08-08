hyprctl -j binds | jq -r '
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
      "slash": "/"
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
' | column -t -s "$(printf '\t')" | fuzzel --dmenu --prompt "keys  " >/dev/null || true
