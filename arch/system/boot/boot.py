import decman
from decman.plugins import pacman


class Boot(decman.Module):
    def __init__(self):
        super().__init__("boot")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"cryptsetup", "limine"}
