{ config, ... }:
{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        include = "${config.xdg.configHome}/fuzzel/noctalia.ini";
        font = "monospace:size=11";
        width = 64;
        lines = 20;
        horizontal-pad = 20;
        vertical-pad = 12;
        inner-pad = 6;
      };

      border = {
        width = 1;
        radius = 12;
      };
    };
  };
}
