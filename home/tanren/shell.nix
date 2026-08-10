{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-index-database.homeModules.default ];

  xdg.configFile = {
    "fastfetch/owl-dark.png".source = ./fastfetch/owl-dark.png;
    "fastfetch/owl-light.png".source = ./fastfetch/owl-light.png;
  };

  programs = {
    nix-index-database.comma.enable = true;

    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
        if set -q KITTY_WINDOW_ID
          fastfetch --logo ~/.config/fastfetch/owl-(noctalia msg theme-mode-get 2>/dev/null; or echo dark).png --logo-type kitty-direct --logo-width 36
        end
      '';
    };

    starship.enable = true;
    zoxide.enable = true;

    carapace = {
      enable = true;
      ignoreCase = true;
    };

    nix-your-shell = {
      enable = true;
      nix-output-monitor.enable = true;
    };

    fzf = {
      enable = true;
      historyWidget.command = "";
    };

    atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
        "--disable-ai"
      ];
      forceOverwriteSettings = true;
      settings = {
        auto_sync = false;
        update_check = false;
        enter_accept = false;
        style = "compact";
        inline_height = 20;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      icons = "auto";
      git = true;
    };

    bat.enable = true;
    btop.enable = true;
    yazi.enable = true;
    fastfetch.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    git = {
      enable = true;
      settings.user = {
        name = "tanren";
        email = "hello@tanren.dev";
      };
    };

  };

  home.packages = with pkgs; [
    fd
    jq
    ouch
    p7zip
    sd
    unzip
    wl-clipboard
    zip
  ];
}
