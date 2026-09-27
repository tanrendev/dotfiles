import decman
from decman.plugins import aur


class Browsers(decman.Module):
    def __init__(self):
        super().__init__("browsers")

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"brave-origin-bin"}
