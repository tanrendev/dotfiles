import decman
from decman import File
from decman.plugins import aur, pacman


class Chat(decman.Module):
    def __init__(self):
        super().__init__("chat")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"telegram-desktop"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"vesktop-bin"}

    def files(self) -> dict[str, File]:
        return {
            "/home/tanren/.config/vesktop/settings.json": File(
                source_file="home/chat/settings.json", owner="tanren"
            ),
        }
