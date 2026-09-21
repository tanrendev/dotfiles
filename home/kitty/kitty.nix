{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    settings = {
      window_padding_width = 8;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };

    extraConfig = ''
      include dark-theme.auto.conf
      globinclude current-theme.conf
    '';
  };

  xdg.configFile = {
    "kitty/dark-theme.auto.conf".source = ./orikalk-lapis-dark.conf;
    "kitty/light-theme.auto.conf".source = ./orikalk-lapis-light.conf;
  };
}
