import decman
from decman import File
from decman.plugins import pacman, systemd


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
        return {
            "/etc/systemd/user/noctalia.service": File(source_file="home/noctalia/noctalia.service"),
            "/home/tanren/.config/noctalia/config.toml": File(
                source_file="home/noctalia/config.toml", owner="tanren"
            ),
        }
