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

    vscode.enable = true;
  };
}
