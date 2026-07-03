{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #dolphin-overlay.url = "github:rumboon/dolphin-overlay";
    warcraftlogs.url = "github:wobbier/warcraftlogs-nixos";
    warcraftlogs.inputs.nixpkgs.follows = "nixpkgs";
    archon.url = "github:wobbier/archon-nix";
    archon.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    odysseus.url = "github:pewdiepie-archdaemon/odysseus/pull/2568/head";
    odysseus.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, warcraftlogs, archon, spicetify-nix, odysseus, ... } @ inputs: #dolphin-overlay, 
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
            warcraftlogs.packages.${system}.warcraftlogs
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

        {
          environment.systemPackages = [
            warcraftlogs.packages.${system}.warcraftlogs
          ];

          #nixpkgs.overlays = [
          #  dolphin-overlay.overlays.default
          #];
        }
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
