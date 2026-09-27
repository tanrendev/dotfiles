import decman
from decman import File
from decman.plugins import aur, pacman, systemd

here = "system/greeter"


class Greeter(decman.Module):
    def __init__(self):
        super().__init__("greeter")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"accountsservice", "greetd"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"noctalia-greeter"}

    @systemd.units
    def units(self) -> set[str]:
        return {"accounts-daemon.service", "greetd.service"}

    def files(self) -> dict[str, File]:
        return {
            "/etc/greetd/config.toml": File(source_file=f"{here}/config.toml"),
            "/var/lib/noctalia-greeter/greeter.toml": File(
                source_file=f"{here}/greeter.toml", owner="greeter"
            ),
            "/etc/polkit-1/rules.d/49-noctalia-greeter-sync.rules": File(
                source_file=f"{here}/49-noctalia-greeter-sync.rules"
            ),
        }
