# Packages for remote working
{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    openconnect
    openconnect_openssl
    parsec-bin
    slack
  ];
}
