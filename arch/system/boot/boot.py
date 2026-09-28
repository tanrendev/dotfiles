import decman
from decman.plugins import pacman


class Boot(decman.Module):
    def __init__(self):
        super().__init__("boot")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"cryptsetup", "limine"}

    def after_update(self, store):
        table = decman.prg(["dmsetup", "table", "root"], pty=False)
        if "allow_discards" not in table:
            decman.prg(["cryptsetup", "--allow-discards", "--persistent", "refresh", "root"])
