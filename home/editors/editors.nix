{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.nano
    pkgs.ty
  ];

  xdg.configFile."Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workshop/ostal/dotfiles/home/editors/vscode-settings.json";

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      plugins = [ pkgs.vimPlugins.lazy-nvim ];
      initLua = builtins.readFile ./nvim.lua;
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
          bradlc.vscode-tailwindcss
          charliermarsh.ruff
          davidanson.vscode-markdownlint
          donjayamanne.githistory
          eamodio.gitlens
          ecmel.vscode-html-css
          esbenp.prettier-vscode
          geequlim.godot-tools
          github.vscode-github-actions
          gitlab.gitlab-workflow
          golang.go
          jnoortheen.nix-ide
          jock.svg
          mechatroner.rainbow-csv
          ms-azuretools.vscode-containers
          ms-azuretools.vscode-docker
          ms-python.debugpy
          ms-python.mypy-type-checker
          ms-python.python
          ms-python.vscode-pylance
          ms-python.vscode-python-envs
          ms-vscode-remote.remote-containers
          ms-vscode.cmake-tools
          ms-vscode.cpptools
          naumovs.color-highlight
          redhat.vscode-yaml
          rust-lang.rust-analyzer
          stylelint.vscode-stylelint
          sumneko.lua
          tamasfe.even-better-toml
          timonwong.shellcheck
          usernamehw.errorlens
          vscode-icons-team.vscode-icons
          wholroyd.jinja
          yzhang.markdown-all-in-one
        ]
        ++ [
          (pkgs.vscode-utils.extensionFromVscodeMarketplace {
            publisher = "astral-sh";
            name = "ty";
            version = "2026.70.0";
            sha256 = "0iq0aj9h543wnbsyx035w08z1y7w8plryfz71bcyl4diw8wmmpz8";
          })
          (pkgs.vscode-utils.extensionFromVscodeMarketplace {
            publisher = "JohnnyMorganz";
            name = "luau-lsp";
            version = "1.69.0";
            sha256 = "1fbpaiy46wdc6qfb14z9dbavcy7djnk30mc4638r3nmycc1kir8q";
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
