import decman
from decman import File
from decman.plugins import aur, pacman


class Media(decman.Module):
    def __init__(self):
        super().__init__("media")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"mpv", "mpv-mpris", "swayimg", "vlc", "vlc-plugins-all"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"mpv-thumbfast-git", "mpv-uosc"}

    def files(self) -> dict[str, File]:
        return {
            "/home/tanren/.config/mpv/mpv.conf": File(
                source_file="home/media/mpv.conf", owner="tanren"
            ),
        }
