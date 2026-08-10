{
  lib,
  runCommand,
  writeText,
  hyprcursor,
  librsvg,
  xcursorgen,
}:
let
  name = "grimoire-cursors";
  size = 32;
  px = f: toString (builtins.floor (builtins.fromJSON f * size + 0.5));

  arrow = {
    x = "0.22";
    y = "0.19";
    over = [ ];
  };
  center = {
    x = "0.5";
    y = "0.5";
    over = [ ];
  };
  zoom = {
    x = "0.44";
    y = "0.44";
    over = [ ];
  };

  shapes = {
    "default" = {
      x = "0.22";
      y = "0.16";
      over = [
        "left_ptr"
        "arrow"
        "top_left_arrow"
        "context-menu"
      ];
    };
    "default-alt" = arrow;
    "pointer" = {
      x = "0.5";
      y = "0.22";
      over = [
        "pointing_hand"
        "hand2"
      ];
    };
    "hand" = {
      x = "0.6";
      y = "0.22";
      over = [ "hand1" ];
    };
    "text" = center // {
      over = [
        "xterm"
        "ibeam"
        "vertical-text"
      ];
    };
    "wait" = arrow // {
      over = [
        "watch"
        "progress"
        "half-busy"
        "left_ptr_watch"
      ];
    };
    "help" = center // {
      over = [
        "question_arrow"
        "whats_this"
      ];
    };
    "copy" = arrow // {
      over = [
        "dnd-copy"
        "alias"
        "dnd-ask"
      ];
    };
    "not-allowed" = arrow // {
      over = [
        "no-drop"
        "forbidden"
        "crossed_circle"
        "dnd-no-drop"
      ];
    };
    "crosshair" = center // {
      over = [
        "cross"
        "tcross"
        "cell"
      ];
    };
    "move" = center // {
      over = [
        "all-scroll"
        "fleur"
        "size_all"
      ];
    };
    "grab" = center // {
      over = [ "openhand" ];
    };
    "grabbing" = center // {
      over = [
        "closedhand"
        "dnd-move"
        "dnd-none"
      ];
    };
    "zoom-in" = zoom // {
      over = [ "zoom_in" ];
    };
    "zoom-out" = zoom // {
      over = [ "zoom_out" ];
    };
    "n-resize" = center // {
      over = [ "top_side" ];
    };
    "s-resize" = center // {
      over = [ "bottom_side" ];
    };
    "e-resize" = center // {
      over = [ "right_side" ];
    };
    "w-resize" = center // {
      over = [ "left_side" ];
    };
    "ne-resize" = center // {
      over = [ "top_right_corner" ];
    };
    "nw-resize" = center // {
      over = [ "top_left_corner" ];
    };
    "se-resize" = center // {
      over = [ "bottom_right_corner" ];
    };
    "sw-resize" = center // {
      over = [ "bottom_left_corner" ];
    };
    "ns-resize" = center // {
      over = [
        "size_ver"
        "sb_v_double_arrow"
        "v_double_arrow"
      ];
    };
    "ew-resize" = center // {
      over = [
        "size_hor"
        "sb_h_double_arrow"
        "h_double_arrow"
      ];
    };
    "nesw-resize" = center // {
      over = [
        "size_bdiag"
        "fd_double_arrow"
      ];
    };
    "nwse-resize" = center // {
      over = [
        "size_fdiag"
        "bd_double_arrow"
      ];
    };
    "col-resize" = center // {
      over = [ "split_h" ];
    };
    "row-resize" = center // {
      over = [ "split_v" ];
    };
    "resize-up" = center // {
      over = [
        "up-arrow"
        "sb_up_arrow"
      ];
    };
    "resize-down" = center // {
      over = [
        "down-arrow"
        "sb_down_arrow"
      ];
    };
    "resize-left" = center // {
      over = [
        "left-arrow"
        "sb_left_arrow"
      ];
    };
    "resize-right" = center // {
      over = [
        "right-arrow"
        "sb_right_arrow"
      ];
    };
    "rotate-top-left" = center;
    "rotate-top-right" = center;
    "rotate-bottom-left" = center;
    "rotate-bottom-right" = center;
    "screenshot" = center;
  };

  manifest = writeText "manifest.hl" ''
    name = ${name}
    description = pixelarticons pixel art cursors
    version = 1.0
    cursors_directory = hyprcursors
  '';

  meta =
    shape: s:
    writeText "${shape}-meta.hl" ''
      resize_algorithm = none
      hotspot_x = ${s.x}
      hotspot_y = ${s.y}
      ${
        lib.concatMapStrings (o: ''
          define_override = ${o}
        '') s.over
      }define_size = 0, ${shape}.svg
    '';

  indexTheme = writeText "index.theme" ''
    [Icon Theme]
    Name=${name}
  '';
in
runCommand name
  {
    nativeBuildInputs = [
      hyprcursor
      librsvg
      xcursorgen
    ];
  }
  ''
    theme=$out/share/icons/${name}
    mkdir -p work/hyprcursors out "$theme/cursors"
    cp ${manifest} work/manifest.hl
    cp ${indexTheme} "$theme/index.theme"
    ${lib.concatStrings (
      lib.mapAttrsToList (shape: s: ''
        mkdir work/hyprcursors/${shape}
        cp ${./svg}/${shape}.svg work/hyprcursors/${shape}/${shape}.svg
        cp ${meta shape s} work/hyprcursors/${shape}/meta.hl
        rsvg-convert -w ${toString size} -h ${toString size} ${./svg}/${shape}.svg -o ${shape}.png
        echo "${toString size} ${px s.x} ${px s.y} ${shape}.png" > ${shape}.cfg
        xcursorgen ${shape}.cfg "$theme/cursors/${shape}"
        ${lib.concatMapStrings (o: ''
          ln -s ${shape} "$theme/cursors/${o}"
        '') s.over}
      '') shapes
    )}
    hyprcursor-util --create work --output out
    cp -r out/*/. "$theme"/
  ''
