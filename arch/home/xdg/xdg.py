import base64
import hashlib
import os
import pwd
import urllib.request

import decman
from decman import Directory, File
from decman.plugins import pacman

home = "/home/tanren"
here = "home/xdg"
cache = "/var/cache/nixos-artwork"
artwork = "https://raw.githubusercontent.com/NixOS/nixos-artwork"

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

fallbacks = {
    "NixOS-Gradient-grey.png": (
        "3f7695afe75239720a32d6c38df7c9888b5ed581",
        "sha256-Tf4Xruf608hpl7YwL4Mq9l9egBOCN+W4KFKnqrgosLE=",
    ),
    "nix-wallpaper-moonscape.png": (
        "bcdd2770f5f4839fddc9b503e68db2bc3a87ca4d",
        "sha256-AR3W8avHzQLxMNLfD/A1efyZH+vAdTLKllEhJwBl0xc=",
    ),
    "nix-wallpaper-nineish-dark-gray.png": (
        "f07707cecfd89bc1459d5dad76a3a4c5315efba1",
        "sha256-nhIUtCy/Hb8UbuxXeL3l3FMausjQrnjTVi1B3GkL9B8=",
    ),
    "nix-wallpaper-waterfall.png": (
        "bcdd2770f5f4839fddc9b503e68db2bc3a87ca4d",
        "sha256-ULFNUZPU9khDG6rtkMskLe5sYpUcrJVvcFvEkpvXjMM=",
    ),
}


def fetch(name: str, rev: str, sri: str) -> str:
    path = f"{cache}/{name}"
    if not os.path.exists(path):
        with urllib.request.urlopen(f"{artwork}/{rev}/wallpapers/{name}") as response:
            data = response.read()
        if "sha256-" + base64.b64encode(hashlib.sha256(data).digest()).decode() != sri:
            raise decman.SourceError(f"Hash mismatch for {name}.")
        os.makedirs(cache, exist_ok=True)
        with open(path, "wb") as file:
            file.write(data)
    return path


class Xdg(decman.Module):
    def __init__(self):
        super().__init__("xdg")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"xdg-user-dirs"}

    def files(self) -> dict[str, File]:
        dirs = "".join(f'XDG_{key}_DIR="{home}/{name}"\n' for key, name in user_dirs.items())
        files = {
            f"{home}/.config/user-dirs.dirs": File(content=dirs, owner="tanren"),
            f"{home}/.config/user-dirs.conf": File(content="enabled=False\n", owner="tanren"),
            f"{home}/.config/mimeapps.list": File(
                source_file=f"{here}/mimeapps.list", owner="tanren"
            ),
            f"{home}/Videos/Wallpapers/.keep": File(content="", owner="tanren"),
        }
        for name, (rev, sri) in fallbacks.items():
            files[f"{home}/Pictures/Wallpapers/{name}"] = File(
                source_file=fetch(name, rev, sri), bin_file=True, owner="tanren"
            )
        return files

    def directories(self) -> dict[str, Directory]:
        return {
            f"{home}/Pictures/Wallpapers": Directory(
                source_directory=f"{here}/wallpapers", bin_files=True, owner="tanren"
            ),
        }

    def after_update(self, store):
        user = pwd.getpwnam("tanren")
        for name in user_dirs.values():
            path = f"{home}/{name}"
            if not os.path.isdir(path):
                os.mkdir(path)
                os.chown(path, user.pw_uid, user.pw_gid)
