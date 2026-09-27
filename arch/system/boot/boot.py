import decman
from decman import File
from decman.plugins import aur, pacman

here = "system/boot"
params = [
    "quiet",
    "splash",
    "loglevel=0",
    "udev.log_level=3",
    "rd.udev.log_level=3",
]


class Boot(decman.Module):
    def __init__(self):
        super().__init__("boot")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"cryptsetup", "limine", "plymouth"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"plymouth-theme-catppuccin-mocha-git"}

    def files(self) -> dict[str, File]:
        return {
            "/etc/mkinitcpio.conf.d/hooks.conf": File(source_file=f"{here}/hooks.conf"),
            "/etc/plymouth/plymouthd.conf": File(source_file=f"{here}/plymouthd.conf"),
        }

    def after_update(self, store):
        decman.prg(["bash", f"{here}/cmdline.sh", *params])

    def on_change(self, store):
        self.after_update(store)
        decman.prg(["mkinitcpio", "-P"])
