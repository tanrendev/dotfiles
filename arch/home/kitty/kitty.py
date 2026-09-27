import decman
from decman import File
from decman.plugins import pacman

config = "/home/tanren/.config/kitty"


class Kitty(decman.Module):
    def __init__(self):
        super().__init__("kitty")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"kitty"}

    def files(self) -> dict[str, File]:
        return {
            f"{config}/kitty.conf": File(source_file="home/kitty/kitty.conf", owner="tanren"),
            f"{config}/dark-theme.auto.conf": File(
                source_file="../home/kitty/orikalk-lapis-dark.conf", owner="tanren"
            ),
            f"{config}/light-theme.auto.conf": File(
                source_file="../home/kitty/orikalk-lapis-light.conf", owner="tanren"
            ),
        }
