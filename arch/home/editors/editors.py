import decman
from decman import File, Symlink
from decman.plugins import aur, pacman

home = "/home/tanren"


class Editors(decman.Module):
    def __init__(self):
        super().__init__("editors")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"nano"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"visual-studio-code-bin"}

    def files(self) -> dict[str, File]:
        return {
            f"{home}/.config/environment.d/editor.conf": File(
                source_file="home/editors/editor.conf", owner="tanren"
            ),
        }

    def symlinks(self) -> dict[str, str | Symlink]:
        return {
            f"{home}/.config/Code/User/settings.json": Symlink(
                f"{home}/Workshop/ostal/dotfiles/arch/home/editors/vscode-settings.json",
                owner="tanren",
            ),
        }
