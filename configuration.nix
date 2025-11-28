# Root NixOS configuration dispatcher + Home Manager integration

{ config, pkgs, ... }:

let
  # Pin Home Manager 25.05 as a tarball
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{
  ########################################
  # Imports
  ########################################
  imports = [
    (import "${home-manager}/nixos")  # Home Manager NixOS module
    ./hosts/danktank/configuration.nix
  ];

  ########################################
  # Home Manager configuration entries
  ########################################
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-bak";

  # Wire Mitch's home config
  home-manager.users.mitch = import ./home/mitch.nix;
}
