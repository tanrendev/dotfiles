import decman
from decman import File
from decman.plugins import aur, pacman

here = "home/gtk"
config = "/home/tanren/.config"
settings = File(source_file=f"{here}/settings.ini", owner="tanren")
patch = "/usr/local/lib/papirus.sh"


class Gtk(decman.Module):
    def __init__(self):
        super().__init__("gtk")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"adw-gtk-theme", "gtk-update-icon-cache", "papirus-icon-theme", "qt5ct", "qt6ct"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"papirus-folders"}

    def files(self) -> dict[str, File]:
        return {
            patch: File(source_file=f"{here}/papirus.sh"),
            "/etc/pacman.d/hooks/papirus.hook": File(source_file=f"{here}/papirus.hook"),
            "/etc/pacman.d/hooks/papirus-reset.hook": File(source_file=f"{here}/papirus-reset.hook"),
            "/etc/dconf/profile/user": File(source_file=f"{here}/dconf-profile"),
            "/etc/dconf/db/local.d/gtk": File(source_file=f"{here}/dconf.ini"),
            f"{config}/gtk-3.0/settings.ini": settings,
            f"{config}/gtk-4.0/settings.ini": settings,
            "/home/tanren/.gtkrc-2.0": File(source_file=f"{here}/gtkrc-2.0", owner="tanren"),
            f"{config}/environment.d/qt.conf": File(source_file=f"{here}/qt.conf", owner="tanren"),
        }

    def on_change(self, store):
        decman.prg(["dconf", "update"])
        decman.prg(["sh", patch], env_overrides={"out": "/usr"})
