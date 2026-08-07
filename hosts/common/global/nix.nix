{ lib, inputs, ... }:
{
  nix = {
    registry = lib.mapAttrs (_: flake: { inherit flake; }) (
      lib.filterAttrs (_: lib.isType "flake") inputs
    );
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;
}
