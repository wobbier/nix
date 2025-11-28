# NixOS system configuration
# Host: nixos (physical machine: "danktank")
# Role: personal desktop / gaming workstation

{ config, pkgs, ... }:

{
  ########################################
  # Imports
  ########################################
  imports = [
    ../../hardware-configuration.nix  # machine-specific, gitignored at repo root
    ../../modules/common.nix          # shared config for all machines
  ];

  ########################################
  # Boot (host-specific)
  ########################################
  boot.loader.grub = {    
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
  };

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ########################################
  # Networking (host-specific bits)
  ########################################
  networking.hostName = "nixos"; # later we can rename this to "danktank"

  ########################################
  # Graphics (OpenGL / Nvidia) — host-specific
  ########################################
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  ########################################
  # System State Version (host-specific)
  ########################################
  system.stateVersion = "25.05"; # Did you read the comment?
}
