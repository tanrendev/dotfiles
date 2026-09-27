import decman
from decman import File
from decman.plugins import pacman


class Pdf(decman.Module):
    def __init__(self):
        super().__init__("pdf")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"zathura", "zathura-pdf-mupdf", "zathura-djvu", "zathura-ps"}

    def files(self) -> dict[str, File]:
        return {
            "/home/tanren/.config/zathura/zathurarc": File(
                source_file="home/pdf/zathurarc", owner="tanren"
            ),
        }
