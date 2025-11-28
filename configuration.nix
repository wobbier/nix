# Root NixOS configuration dispatcher
# For now, this machine uses the "danktank" host config.

{ config, pkgs, ... }:

{
  imports = [
    ./hosts/danktank/configuration.nix
  ];
}
