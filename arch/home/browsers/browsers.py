import json

import decman
from decman import File
from decman.plugins import aur, pacman

defaults = "/usr/lib/librewolf/distribution/policies.json"


class Browsers(decman.Module):
    def __init__(self):
        super().__init__("browsers")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"librewolf", "torbrowser-launcher"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"brave-origin-bin", "python-pywalfox"}

    def files(self) -> dict[str, File]:
        with open(defaults) as file:
            policies = json.load(file)
        with open("home/browsers/extensions.json") as file:
            policies["policies"].setdefault("ExtensionSettings", {}).update(json.load(file))
        return {
            "/etc/librewolf/policies/policies.json": File(content=json.dumps(policies, indent=2) + "\n"),
        }
