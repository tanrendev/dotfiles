{ pkgs, ... }:
{
  home.packages = [ pkgs.nano ];

  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
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
      profiles.default.userSettings = {
        "extensions.autoUpdate" = false;
        "extensions.autoCheckUpdates" = false;
        "extensions.ignoreRecommendations" = true;
        "telemetry.telemetryLevel" = "off";
        "workbench.enableExperiments" = false;
        "workbench.settings.enableNaturalLanguageSearch" = false;
        "update.mode" = "none";
        "update.showReleaseNotes" = false;
        "npm.fetchOnlinePackageInfo" = false;
        "gitlens.telemetry.enabled" = false;
        "redhat.telemetry.enabled" = false;
        "claudeCode.preferredLocation" = "panel";
        "git.confirmSync" = false;
        "json.schemaDownload.trustedDomains" = {
          "https://schemastore.azurewebsites.net/" = true;
          "https://raw.githubusercontent.com/microsoft/vscode/" = true;
          "https://raw.githubusercontent.com/devcontainers/spec/" = true;
          "https://www.schemastore.org/" = true;
          "https://json.schemastore.org/" = true;
          "https://json-schema.org/" = true;
          "https://developer.microsoft.com/json-schemas/" = true;
          "https://biomejs.dev" = true;
        };
      };
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
