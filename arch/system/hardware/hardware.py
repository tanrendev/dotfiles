import decman
from decman import File
from decman.plugins import pacman, systemd

here = "system/hardware"


class Hardware(decman.Module):
    def __init__(self):
        super().__init__("hardware")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {
            "ffmpeg",
            "intel-gpu-tools",
            "intel-media-driver",
            "libva-utils",
            "mesa",
            "thermald",
            "vulkan-intel",
        }

    @systemd.units
    def units(self) -> set[str]:
        return {"thermald.service"}

    def files(self) -> dict[str, File]:
        return {
            "/etc/environment": File(source_file=f"{here}/environment"),
            "/etc/tmpfiles.d/battery.conf": File(source_file=f"{here}/battery.conf"),
        }
