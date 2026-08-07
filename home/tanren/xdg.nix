{ config, ... }:
{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    projects = "${config.home.homeDirectory}/Workshop";
  };

  home.file."Pictures/Wallpapers/.keep".text = "";
}
