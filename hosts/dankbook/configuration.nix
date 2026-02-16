# NixOS system configuration
# Host: dankbook
# Role: MacBook Pro 14,3

{ config, pkgs, ... }:

{
  ########################################
  # Imports
  ########################################
  imports = [
    ../../hardware-configuration.nix
    ../../modules/common.nix
  ];

  ########################################
  # Boot (Mac EFI)
  ########################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.grub.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  ########################################
  # Kernel
  ########################################
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ########################################
  # Hostname
  ########################################
  networking.hostName = "dankbook";

  ########################################
  # Broadcom BCM43602 Fix
  ########################################
  hardware.firmware = [
    pkgs.linux-firmware

    (pkgs.runCommand "bcm43602-boardfile" {} ''
      mkdir -p $out/lib/firmware/brcm
      cp ${./brcmfmac43602-pcie.txt} \
         $out/lib/firmware/brcm/brcmfmac43602-pcie.txt
    '')
  ];

  ########################################
  # Power tweaks (optional but recommended)
  ########################################
  services.tlp.enable = true;
  powerManagement.enable = true;

  ########################################
  # System Version
  ########################################
  system.stateVersion = "25.05";
}
