{
  description = "tanren's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    claude-code.url = "github:sadjow/claude-code-nix";

    familiar = {
      url = "github:tanrendev/familiar";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-plugins = {
      url = "github:noctalia-dev/official-plugins";
      flake = false;
    };

    patina = {
      url = "github:tanrendev/patina";
      flake = false;
    };

    umbriel.url = "git+https://github.com/noctalia-dev/umbriel";

    xdg-desktop-portal-umbriel.url = "github:noctalia-dev/xdg-desktop-portal-umbriel";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
      lyngenPkgs = self.nixosConfigurations.lyngen.pkgs;
    in
    {
      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      overlays.default = import ./pkgs;

      packages = forAllSystems (pkgs: {
        inherit (lyngenPkgs) grok-bot signal-desktop vscode;
        update-debs = pkgs.callPackage ./pkgs/update-debs/package.nix { };
        update-vscode-extensions = lyngenPkgs.callPackage ./pkgs/update-vscode-extensions/package.nix { };
      });

      nixosConfigurations.lyngen = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./nixos ];
      };

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nixfmt
            statix
            deadnix
            zizmor
            prek
          ];
        };
      });
    };
}
