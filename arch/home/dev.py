import decman
from decman.plugins import aur, pacman


class Dev(decman.Module):
    def __init__(self):
        super().__init__("dev")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"github-cli"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"claude-code"}
