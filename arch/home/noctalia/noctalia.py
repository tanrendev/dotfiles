import decman
from decman import File
from decman.plugins import pacman, systemd

config = "/home/tanren/.config/noctalia"
palettes = ["lapis", "lyngen", "orikalk", "orikalk-lapis"]


class Noctalia(decman.Module):
    def __init__(self):
        super().__init__("noctalia")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"noctalia"}

    @systemd.user_units
    def user_units(self) -> dict[str, set[str]]:
        return {"tanren": {"noctalia.service"}}

    def files(self) -> dict[str, File]:
        files = {
            "/etc/systemd/user/noctalia.service": File(source_file="home/noctalia/noctalia.service"),
            f"{config}/config.toml": File(source_file="home/noctalia/config.toml", owner="tanren"),
            f"{config}/theme-mode-hook.sh": File(
                source_file="home/noctalia/theme-mode-hook.sh", owner="tanren"
            ),
        }
        for palette in palettes:
            files[f"{config}/palettes/{palette}.json"] = File(
                source_file=f"home/noctalia/{palette}.json", owner="tanren"
            )
        return files
