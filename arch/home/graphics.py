import decman
from decman.plugins import aur, pacman


class Graphics(decman.Module):
    def __init__(self):
        super().__init__("graphics")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"fontforge", "gimp", "hyprpicker", "inkscape"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"aseprite"}
