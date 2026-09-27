import decman
from decman.plugins import pacman


class Office(decman.Module):
    def __init__(self):
        super().__init__("office")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"libreoffice-fresh", "libreoffice-fresh-en-gb"}
