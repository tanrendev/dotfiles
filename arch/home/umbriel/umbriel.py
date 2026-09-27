import decman
from decman import File
from decman.plugins import aur, pacman

config = "/home/tanren/.config/umbriel"
parts = ["general", "input", "keybinds", "rules"]


class Umbriel(decman.Module):
    def __init__(self):
        super().__init__("umbriel")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"xwayland-satellite"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"umbriel-git", "xdg-desktop-portal-umbriel-git"}

    def files(self) -> dict[str, File]:
        files = {
            f"{config}/config.toml": File(source_file="home/umbriel/config.toml", owner="tanren")
        }
        for part in parts:
            files[f"{config}/{part}.toml"] = File(
                source_file=f"home/umbriel/{part}.toml", owner="tanren"
            )
        return files
