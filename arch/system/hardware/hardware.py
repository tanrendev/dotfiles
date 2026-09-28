import decman
from decman import File
from decman.plugins import pacman, systemd


class Hardware(decman.Module):
    def __init__(self):
        super().__init__("hardware")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"intel-media-driver", "mesa", "thermald", "vulkan-intel"}

    @systemd.units
    def units(self) -> set[str]:
        return {"thermald.service"}

    def files(self) -> dict[str, File]:
        return {"/var/lib/upower/charging-threshold-status": File(content="1")}
