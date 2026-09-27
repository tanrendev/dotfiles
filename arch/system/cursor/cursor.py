import os

import decman
from decman import File
from decman.plugins import aur

here = os.path.abspath("system/cursor")


class Cursor(decman.Module):
    def __init__(self):
        super().__init__("cursor")

    @aur.custom_packages
    def custom_packages(self) -> set[aur.CustomPackage]:
        return {
            aur.CustomPackage("grimoire-cursors", pkgbuild_directory=f"{here}/grimoire-cursors")
        }

    def files(self) -> dict[str, File]:
        return {"/etc/environment.d/cursor.conf": File(source_file="system/cursor/cursor.conf")}
