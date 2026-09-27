import decman
from decman import File
from decman.plugins import pacman


class Cursor(decman.Module):
    def __init__(self):
        super().__init__("cursor")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"adwaita-cursors"}

    def files(self) -> dict[str, File]:
        return {"/etc/environment.d/cursor.conf": File(source_file="system/cursor/cursor.conf")}
