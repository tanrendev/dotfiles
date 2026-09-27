import decman
from decman.plugins import pacman


class Media(decman.Module):
    def __init__(self):
        super().__init__("media")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"swayimg", "vlc", "vlc-plugins-all"}
