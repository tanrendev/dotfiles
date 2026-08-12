{ config, pkgs, ... }:
{
  home.packages = [ pkgs.nano ];

  xdg.configFile."Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workshop/ostal/home/tanren/vscode-settings.json";

  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "noctalia";
        editor = {
          line-number = "relative";
          cursorline = true;
          true-color = true;
          bufferline = "multiple";
          indent-guides.render = true;
          lsp.display-messages = true;
        };
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    vscode = {
      enable = true;
      mutableExtensionsDir = true;
      profiles.default.extensions =
        with pkgs.vscode-extensions;
        [
          anthropic.claude-code
          batisteo.vscode-django
          biomejs.biome
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          charliermarsh.ruff
          davidanson.vscode-markdownlint
          eamodio.gitlens
          ecmel.vscode-html-css
          esbenp.prettier-vscode
          geequlim.godot-tools
          golang.go
          jnoortheen.nix-ide
          ms-azuretools.vscode-docker
          ms-python.python
          ms-vscode.cmake-tools
          ms-vscode.cpptools
          redhat.vscode-yaml
          rust-lang.rust-analyzer
          sumneko.lua
          tamasfe.even-better-toml
          timonwong.shellcheck
          wholroyd.jinja
        ]
        ++ [
          (pkgs.vscode-utils.extensionFromVscodeMarketplace {
            publisher = "astral-sh";
            name = "ty";
            version = "2026.66.0";
            sha256 = "0fl6c1p86sm39j7rbzwp0i0s6s6ny9ibsp98c8hc5vr65jllyqmr";
          })
          (pkgs.vscode-utils.extensionFromVscodeMarketplace {
            publisher = "oven";
            name = "bun-vscode";
            version = "0.0.32";
            sha256 = "1r8gc4m5ylyszr1vrhf8xp93siqcpaxdcmjmhlazrrw5g0wfwnjn";
          })
        ];
    };
  };
}
