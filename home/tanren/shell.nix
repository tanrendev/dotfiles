{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = "set -g fish_greeting";
    };

    starship.enable = true;
    fzf.enable = true;
    zoxide.enable = true;

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
    p7zip
    unzip
    wl-clipboard
    zip
  ];
}
