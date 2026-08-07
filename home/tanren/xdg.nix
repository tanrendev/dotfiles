{ config, ... }:
{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      projects = "${config.home.homeDirectory}/Workshop";
    };

    mimeApps.defaultApplications."inode/directory" = "thunar.desktop";
  };

  home.file."Pictures/Wallpapers/.keep".text = "";
}
