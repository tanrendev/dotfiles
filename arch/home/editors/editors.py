import os

import decman
from decman import File, Symlink
from decman.plugins import pacman

home = "/home/tanren"
here = os.path.abspath("home/editors")
marketplace = "/usr/local/lib/code-marketplace"


class Editors(decman.Module):
    def __init__(self):
        super().__init__("editors")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"code", "jq", "nano"}

    def files(self) -> dict[str, File]:
        return {
            f"{home}/.config/environment.d/editor.conf": File(
                source_file="home/editors/editor.conf", owner="tanren"
            ),
            marketplace: File(source_file="home/editors/code-marketplace.sh", permissions=0o755),
            "/etc/pacman.d/hooks/code-marketplace.hook": File(
                source_file="home/editors/code-marketplace.hook"
            ),
        }

    def symlinks(self) -> dict[str, str | Symlink]:
        return {
            f"{home}/.config/Code - OSS/User/settings.json": Symlink(
                f"{here}/vscode-settings.json", owner="tanren"
            ),
        }

    def after_update(self, store):
        decman.prg([marketplace])
