import decman
from decman import File
from decman.plugins import pacman, systemd

here = "home/removable_media"


class RemovableMedia(decman.Module):
    def __init__(self):
        super().__init__("removable-media")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"udiskie"}

    @systemd.user_units
    def user_units(self) -> dict[str, set[str]]:
        return {"tanren": {"udiskie.service"}}

    def files(self) -> dict[str, File]:
        return {
            "/etc/systemd/user/udiskie.service": File(source_file=f"{here}/udiskie.service"),
            "/home/tanren/.config/udiskie/config.yml": File(
                source_file=f"{here}/config.yml", owner="tanren"
            ),
        }
