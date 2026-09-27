import decman
from decman import File
from decman.plugins import pacman, systemd

here = "system/desktop"


class Desktop(decman.Module):
    def __init__(self):
        super().__init__("desktop")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {
            "dconf",
            "gvfs",
            "noto-fonts",
            "noto-fonts-cjk",
            "noto-fonts-emoji",
            "power-profiles-daemon",
            "rtkit",
            "thunar",
            "thunar-volman",
            "ttf-dejavu",
            "ttf-jetbrains-mono-nerd",
            "ttf-liberation",
            "tumbler",
            "udisks2",
            "upower",
            "xdg-desktop-portal-gtk",
        }

    @systemd.units
    def units(self) -> set[str]:
        return {"bluetooth.service", "power-profiles-daemon.service"}

    def files(self) -> dict[str, File]:
        return {
            "/etc/brave/policies/managed/extra.json": File(source_file=f"{here}/policies.json"),
        }
