# Root NixOS configuration dispatcher + Home Manager integration

{ config, pkgs, inputs, ... }:

let
  home-manager = inputs.home-manager; # needed?
in
{
  ########################################
  # Imports
  ########################################
  imports = [
    (import "${home-manager}/nixos")  # Home Manager NixOS module
    inputs.spicetify-nix.nixosModules.default
  ];
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  ########################################
  # Home Manager configuration entries
  ########################################
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-bak";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-40.10.5"
  ];

  # Wire Mitch's home config
  home-manager.users.mitch = import ./home/mitch.nix;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-substitution-jobs = 16;
    cores = 0;
    max-jobs = "auto";
  };
}
