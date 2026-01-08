# NixOS system configuration
# Host: virtualdank
# Role: nix config playground in VM

{ config, pkgs, ... }:

{
  ########################################
  # Imports
  ########################################
  imports = [
    ../../hardware-configuration.nix  # machine-specific
    ../../modules/common.nix          # shared config
  ];

  ########################################
  # Boot
  ########################################
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    binutils
  ];

  ########################################
  # Networking
  ########################################
  networking.hostName = "virtualdank";

  ########################################
  # Graphics (OpenGL)
  ########################################
  hardware.graphics.enable = true;

  ########################################
  # System State Version
  ########################################
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
