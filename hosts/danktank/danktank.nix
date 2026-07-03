# NixOS system configuration
# Host: danktank
# Role: personal desktop / gaming workstation

{ config, pkgs, ... }:

{
  ########################################
  # Imports
  ########################################
  imports = [
    ../../hardware-configuration.nix  # machine-specific
    ../../modules/common.nix          # shared config
    ../../modules/gaming.nix          # gaming config
    ../../modules/media.nix           # media / desktop apps
    ../../modules/dev.nix             # dev / gamedev tooling
    ../../modules/work.nix            # work config
    ../../users/mitch.nix             # user config
  ];

  ########################################
  # Boot
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
  # Networking
  ########################################
  networking.hostName = "danktank";

  boot.extraModulePackages = with config.boot.kernelPackages; [
    r8125
  ];

  boot.blacklistedKernelModules = [ "r8169" ];

  ########################################
  # Graphics (OpenGL / Nvidia)
  ########################################

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva
      libvdpau
    ];
  };

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
    open = true;


    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "610.43.02";

      # Make sure to set these to `lib.fakeHash`
      # every time you change the version - nix
      # will trust them, and not redownload the driver.
      sha256_64bit = "sha256-MDSgVLtM33dS/43CclZMsQVROAS/9TU4lFkBsWyndGM=";
      openSha256 = "sha256-hP5NVZZ4vGsACHLmUDKq4uckpd/kn1GxCSYnnJfAuBs=";
      settingsSha256 = "sha256-0YAhufRgjDW+uR+kjaTb154fibpcDw8QowfrucoZsKE=";

      # headless servers only feature, disabling at
      # the package level because that's one less
      # hash to define.
      usePersistenced = false;
    };
  };

  security.polkit.enable = true;

  fileSystems."/mnt/windows/Programs" = {
    device = "/dev/disk/by-uuid/98644EC9644EA9B8";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "nofail" "x-systemd.automount" ];
  };

  fileSystems."/mnt/windows/Tankhouse" = {
    device = "/dev/disk/by-uuid/48E221F9E221EBBE";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "nofail" "x-systemd.automount" ];
  };

  fileSystems."/mnt/windows/WOB" = {
    device = "/dev/disk/by-uuid/7A6AA2086AA1C0ED";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "nofail" "x-systemd.automount" ];
  };

  fileSystems."/mnt/windows/DNA" = {
    device = "/dev/disk/by-uuid/FC7CB12C7CB0E296";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "nofail" "x-systemd.automount" ];
  };

  fileSystems."/mnt/windows/WinNVME1" = {
    device = "/dev/disk/by-uuid/9CC44BA5C44B810E";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "nofail" "x-systemd.automount" ];
  };

  fileSystems."/mnt/windows/WinNVME2" = {
    device = "/dev/disk/by-uuid/34FCC9BFFCC97B9C";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "nofail" "x-systemd.automount" ];
  };

  ########################################
  # Firewall / Networking (optional)
  ########################################
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
