import decman
from decman import File
from decman.plugins import aur, pacman

config = "/home/tanren/.config"


class Shell(decman.Module):
    def __init__(self):
        super().__init__("shell")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {
            "7zip",
            "atuin",
            "bat",
            "btop",
            "direnv",
            "eza",
            "fastfetch",
            "fd",
            "ffmpeg",
            "fzf",
            "git-delta",
            "imagemagick",
            "jq",
            "lazygit",
            "ripgrep",
            "sd",
            "starship",
            "tealdeer",
            "unzip",
            "wl-clipboard",
            "zip",
            "zoxide",
        }

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"carapace-bin"}

    def files(self) -> dict[str, File]:
        return {
            f"{config}/fish/config.fish": File(source_file="home/shell/config.fish", owner="tanren"),
            f"{config}/fish/init.fish": File(source_file="home/shell/init.fish", owner="tanren"),
            f"{config}/atuin/config.toml": File(source_file="home/shell/atuin.toml", owner="tanren"),
            f"{config}/git/config": File(source_file="home/shell/gitconfig", owner="tanren"),
        }
