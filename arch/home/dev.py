import decman
from decman.plugins import aur, pacman


class Dev(decman.Module):
    def __init__(self):
        super().__init__("dev")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {
            "bun",
            "gcc",
            "github-cli",
            "glab",
            "go",
            "godot",
            "lazygit",
            "lua-language-server",
            "luacheck",
            "make",
            "nodejs",
            "npm",
            "pkgconf",
            "rustup",
            "shellcheck",
            "shfmt",
            "stylua",
            "taplo-cli",
            "uv",
            "yaml-language-server",
        }

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"claude-code"}
