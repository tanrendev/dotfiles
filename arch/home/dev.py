import os

import decman
from decman.plugins import pacman

claude = "/home/tanren/.local/bin/claude"


class Dev(decman.Module):
    def __init__(self):
        super().__init__("dev")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {"github-cli"}

    def after_update(self, store):
        if not os.path.exists(claude):
            decman.prg(
                ["bash", "-c", "curl -fsSL https://claude.ai/install.sh | bash"],
                user="tanren",
                mimic_login=True,
            )
