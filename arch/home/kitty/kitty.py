import decman
from decman import File
from decman.plugins import pacman


class Kitty(decman.Module):
    def __init__(self):
        super().__init__("kitty")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"kitty"}

    def files(self) -> dict[str, File]:
        return {
            "/home/tanren/.config/kitty/kitty.conf": File(
                source_file="home/kitty/kitty.conf", owner="tanren"
            ),
        }
