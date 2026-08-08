{ config, pkgs, ... }:
{
  programs = {
    claude-code.enable = true;
    gh.enable = true;
    lazygit.enable = true;

    nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/dotfiles";
    };
  };

  home.packages = with pkgs; [
    bun
    deadnix
    gcc
    glab
    gnumake
    go
    godot
    lua-language-server
    luaPackages.luacheck
    nil
    nix-output-monitor
    nixfmt
    nvd
    pkg-config
    rustup
    shellcheck
    shfmt
    statix
    stylua
    taplo
    uv
    yaml-language-server
  ];
}
