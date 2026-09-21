{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs = {
    claude-code = {
      enable = true;
      package = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    gh.enable = true;
    lazygit.enable = true;

    nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/Workshop/ostal/dotfiles";
    };
  };

  home.packages = with pkgs; [
    bun
    gcc
    glab
    gnumake
    go
    godot
    lua-language-server
    luaPackages.luacheck
    nil
    nix-output-monitor
    nodejs
    nvd
    pkg-config
    rustup
    shellcheck
    shfmt
    stylua
    taplo
    uv
    yaml-language-server
  ];
}
