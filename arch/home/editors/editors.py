import decman
from decman import File, Symlink
from decman.plugins import aur, pacman

home = "/home/tanren"
extensions = [
    "anthropic.claude-code",
    "astral-sh.ty",
    "batisteo.vscode-django",
    "biomejs.biome",
    "charliermarsh.ruff",
    "davidanson.vscode-markdownlint",
    "eamodio.gitlens",
    "ecmel.vscode-html-css",
    "esbenp.prettier-vscode",
    "geequlim.godot-tools",
    "golang.go",
    "jnoortheen.nix-ide",
    "jock.svg",
    "johnnymorganz.luau-lsp",
    "ms-azuretools.vscode-docker",
    "ms-python.python",
    "ms-vscode.cmake-tools",
    "ms-vscode.cpptools",
    "naumovs.color-highlight",
    "oven.bun-vscode",
    "redhat.vscode-yaml",
    "rust-lang.rust-analyzer",
    "sumneko.lua",
    "tamasfe.even-better-toml",
    "timonwong.shellcheck",
    "wholroyd.jinja",
]


class Editors(decman.Module):
    def __init__(self):
        super().__init__("editors")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"nano", "neovim", "ty"}

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"nvim-lazy", "visual-studio-code-bin"}

    def files(self) -> dict[str, File]:
        return {
            f"{home}/.config/nvim/init.lua": File(
                source_file="../home/editors/nvim.lua", owner="tanren"
            ),
            f"{home}/.config/environment.d/editor.conf": File(
                source_file="home/editors/editor.conf", owner="tanren"
            ),
        }

    def symlinks(self) -> dict[str, str | Symlink]:
        return {
            "/usr/local/bin/vi": "/usr/bin/nvim",
            "/usr/local/bin/vim": "/usr/bin/nvim",
            f"{home}/.config/Code/User/settings.json": Symlink(
                f"{home}/Workshop/ostal/dotfiles/home/editors/vscode-settings.json",
                owner="tanren",
            ),
        }

    def after_update(self, store):
        args = [arg for ext in extensions for arg in ("--install-extension", ext)]
        decman.prg(["code", *args], user="tanren", mimic_login=True)
