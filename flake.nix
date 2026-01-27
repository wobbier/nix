{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    dolphin-overlay.url = "github:rumboon/dolphin-overlay";
    warcraftlogs.url = "github:wobbier/warcraftlogs-nixos";
  };

  outputs = { self, nixpkgs, dolphin-overlay, warcraftlogs, ... } @ inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.danktank = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix
        ./hosts/danktank/configuration.nix
        ./hardware-configuration.nix

        {
          environment.systemPackages = [
            warcraftlogs.packages.${system}.warcraftlogs
          ];

          nixpkgs.overlays = [
            dolphin-overlay.overlays.default
          ];
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
        ./hosts/virtualdank/configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
