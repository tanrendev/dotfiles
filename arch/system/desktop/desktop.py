import decman
from decman import File
from decman.plugins import aur, pacman, systemd

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

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"otf-departure-mono"}

    @systemd.units
    def units(self) -> set[str]:
        return {"bluetooth.service", "power-profiles-daemon.service"}

    def files(self) -> dict[str, File]:
        policies = File(source_file=f"{here}/policies.json")
        return {
            "/etc/UPower/UPower.conf": File(source_file=f"{here}/UPower.conf"),
            "/etc/bluetooth/main.conf": File(source_file=f"{here}/main.conf"),
            "/etc/fonts/conf.d/52-default-fonts.conf": File(
                source_file=f"{here}/52-default-fonts.conf"
            ),
            "/etc/brave/policies/managed/extra.json": policies,
        }
