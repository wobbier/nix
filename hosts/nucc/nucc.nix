{ config, pkgs, ... }:

{
  ########################################
  # Imports
  ########################################
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix          # shared config
    ../../modules/server.nix          # shared config
    ../../modules/web.nix             # public *.mitch.gg sites
    ../../modules/snit-bot.nix        # discord bot
    ../../users/mitch.nix             # user config
  ];

  ########################################
  # Boot
  ########################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    binutils
  ];

  ########################################
  # Networking
  ########################################
  networking.hostName = "nucc";

  ########################################
  # Graphics (OpenGL)
  ########################################
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver   # VAAPI for Broadwell+ (iHD driver)
    ];
  };

  ########################################
  # Auto upgrade
  ########################################
  system.autoUpgrade = {
    enable = true;
    flake = "github:wobbier/nix#nucc";
    dates = "Tue 07:00";
    flags = [
      "--update-input" "nixpkgs"
      "--no-write-lock-file"
    ];
    allowReboot = true;
  };

  ########################################
  # System State Version
  ########################################
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
