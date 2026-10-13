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
    awscli2
    bun
    dotnet-runtime_9
    gcc
    glab
    gnumake
    go
    godot
    golangci-lint
    jdk17
    lazydocker
    lua-language-server
    luaPackages.luacheck
    luarocks
    mise
    nil
    nix-output-monitor
    nodejs
    nvd
    opentofu
    pkg-config
    ruby
    rustup
    shellcheck
    shfmt
    stylua
    taplo
    tree-sitter
    uv
    yaml-language-server
  ];
}
