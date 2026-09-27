import decman
from decman.plugins import pacman

conf = "/etc/pacman.conf"
disabled = "#[multilib]\n#Include = /etc/pacman.d/mirrorlist\n"
enabled = "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n"


class Multilib(decman.Module):
    def __init__(self):
        super().__init__("multilib")

    def before_update(self, store):
        with open(conf) as f:
            text = f.read()
        if enabled in text:
            return
        if disabled not in text:
            raise decman.SourceError(f"no multilib section in {conf}")
        with open(conf, "w") as f:
            f.write(text.replace(disabled, enabled))
        decman.prg(["pacman", "-Sy"])

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"lib32-pipewire"}
