import os
import pwd

import decman
from decman import File
from decman.plugins import pacman

home = "/home/tanren"

user_dirs = {
    "DESKTOP": "Desktop",
    "DOCUMENTS": "Documents",
    "DOWNLOAD": "Downloads",
    "MUSIC": "Music",
    "PICTURES": "Pictures",
    "PROJECTS": "Workshop",
    "PUBLICSHARE": "Public",
    "TEMPLATES": "Templates",
    "VIDEOS": "Videos",
}


class Xdg(decman.Module):
    def __init__(self):
        super().__init__("xdg")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"xdg-user-dirs"}

    def files(self) -> dict[str, File]:
        dirs = "".join(f'XDG_{key}_DIR="{home}/{name}"\n' for key, name in user_dirs.items())
        return {
            f"{home}/.config/user-dirs.dirs": File(content=dirs, owner="tanren"),
            f"{home}/.config/user-dirs.conf": File(content="enabled=False\n", owner="tanren"),
            f"{home}/.config/mimeapps.list": File(
                source_file="home/xdg/mimeapps.list", owner="tanren"
            ),
        }

    def after_update(self, store):
        user = pwd.getpwnam("tanren")
        for name in user_dirs.values():
            path = f"{home}/{name}"
            if not os.path.isdir(path):
                os.mkdir(path)
                os.chown(path, user.pw_uid, user.pw_gid)
