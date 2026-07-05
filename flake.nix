{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #dolphin-overlay.url = "github:rumboon/dolphin-overlay";
    archon.url = "github:wobbier/archon-nix";
    archon.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    odysseus.url = "github:pewdiepie-archdaemon/odysseus/pull/2568/head";
    odysseus.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, archon, spicetify-nix, odysseus, ... } @ inputs: #dolphin-overlay,
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.danktank = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./configuration.nix
        ./hosts/danktank/danktank.nix
        #./modules/odysseus.nix
        {
          environment.systemPackages = [
            archon.packages.${system}.archon
          ];

          ##nixpkgs.overlays = [
          ##  dolphin-overlay.overlays.default
          ##];
        }
      ];
    };

    nixosConfigurations.dankbook = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix
        ./hosts/dankbook/dankbook.nix
      ];
    };

    nixosConfigurations.nucc = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix
        ./hosts/nucc/nucc.nix
      ];
    };

    nixosConfigurations.virtualdank = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix
        ./hosts/virtualdank/virtualdank.nix
      ];
    };
  };
}
