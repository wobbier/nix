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

  # Wire Mitch's home config
  home-manager.users.mitch = import ./home/mitch.nix;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
