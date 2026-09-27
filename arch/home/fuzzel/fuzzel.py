import decman
from decman import File
from decman.plugins import pacman


class Fuzzel(decman.Module):
    def __init__(self):
        super().__init__("fuzzel")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"fuzzel"}

    def files(self) -> dict[str, File]:
        return {
            "/home/tanren/.config/fuzzel/fuzzel.ini": File(
                source_file="home/fuzzel/fuzzel.ini", owner="tanren"
            ),
        }
