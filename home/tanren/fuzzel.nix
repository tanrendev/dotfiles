{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
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

      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        prompt = "a6adc8ff";
        input = "cdd6f4ff";
        match = "cba6f7ff";
        selection = "313244ff";
        selection-text = "cdd6f4ff";
        selection-match = "cba6f7ff";
        border = "cba6f7ff";
      };
    };
  };
}
