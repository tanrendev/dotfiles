{ inputs, ... }:
{
  imports = [ inputs.umbriel.homeModules.default ];

  programs.umbriel = {
    enable = true;

    settings = {
      include.files = [
        "${./general.toml}"
        "${./input.toml}"
        "${./keybinds.toml}"
        "${./rules.toml}"
      ];

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
    };
  };
}
