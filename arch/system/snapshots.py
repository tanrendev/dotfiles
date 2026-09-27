import decman
from decman.plugins import pacman, systemd


class Snapshots(decman.Module):
    def __init__(self):
        super().__init__("snapshots")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"snap-pac", "snapper"}

    @systemd.units
    def units(self) -> set[str]:
        return {"snapper-cleanup.timer", "snapper-timeline.timer"}
