final: _: {
  grok-bot = final.callPackage ./grok-bot/package.nix { };
  signal-desktop = final.callPackage ./signal-desktop/package.nix { };
}
