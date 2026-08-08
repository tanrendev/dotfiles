{ pkgs, ... }:
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };

  services.tumbler.enable = true;

  environment.systemPackages = [ pkgs.file-roller ];
}
