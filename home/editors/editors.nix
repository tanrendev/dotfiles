{
  config,
  lib,
  pkgs,
  ...
}:
let
  patchedInNixpkgs = [
    "anthropic.claude-code"
    "charliermarsh.ruff"
    "ms-python.python"
    "ms-vscode.cpptools"
    "sumneko.lua"
  ];

  storeFixes = {
    "ms-python.debugpy" = old: {
      postInstall = (old.postInstall or "") + ''
        mkdir "$out/$installPrefix/.noConfigDebugAdapterEndpoints"
      '';
    };
    "ms-vscode.cpptools" = old: {
      postPatch = old.postPatch + ''
        chmod +x bin/cpptools-srv2
      '';
      postFixup = (old.postFixup or "") + ''
        patchelf --set-interpreter "$out/$installPrefix/bin/libc.so" "$out/$installPrefix/bin/cpptools-srv2"
      '';
    };
  };

  extension =
    pin:
    let
      id = lib.toLower "${pin.publisher}.${pin.name}";
      ref = lib.getAttrs [
        "publisher"
        "name"
        "version"
        "arch"
        "hash"
      ] pin;
      base =
        if lib.elem id patchedInNixpkgs then
          (lib.getAttrFromPath (lib.splitString "." id) pkgs.vscode-extensions).overrideAttrs {
            inherit (pin) version;
            src = pkgs.vscode-utils.fetchVsixFromVscodeMarketplace ref;
          }
        else
          pkgs.vscode-utils.buildVscodeMarketplaceExtension { mktplcRef = ref; };
    in
    base.overrideAttrs (storeFixes.${id} or (_: { }));
in
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
      mutableExtensionsDir = false;
      profiles.default.extensions = map extension (lib.importJSON ./extensions.json);
    };
  };
}
