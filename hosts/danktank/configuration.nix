# NixOS system configuration
# Host: nixos (physical machine: "danktank")
# Role: personal desktop / gaming workstation

{ config, pkgs, ... }:

{
  ########################################
  # Imports
  ########################################
  imports = [
    ./hardware-configuration.nix    # machine-specific, gitignored
    ../../users/mitch.nix           # user module
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
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  ########################################
  # Locale & Time
  ########################################
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  ########################################
  # Display Server / Desktop Environments
  ########################################
  services.xserver.enable = true;

  # Display Manager
  services.xserver.displayManager.gdm.enable = true;

  # Desktop Environments
  services.desktopManager.plasma6.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  ########################################
  # Printing
  ########################################
  services.printing.enable = true;

  ########################################
  # Audio (PipeWire)
  ########################################
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  ########################################
  # Users
  ########################################
  # User accounts are defined in ../../users/mitch.nix (and future users).

  ########################################
  # Login / Session
  ########################################
  services.displayManager.autoLogin.enable = false;

  ########################################
  # Core Programs
  ########################################
  programs.firefox.enable = true;
  programs.steam.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.waybar.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "mitch" ];
  };

  programs.ssh.startAgent = true;

  ########################################
  # System Packages
  ########################################
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # essentials
    vim
    git
    vscode-fhs

    # utilities
    sbctl
    discord
    mangohud
    grim slurp wl-clipboard
    wofi
    p7zip

    # media
    obs-studio
    vlc
    audacity
    spotify

    # dev
    nodejs
    python3
    renderdoc

    # gaming
    steam
    lutris

    # web browser
    google-chrome
  ];

  ########################################
  # Graphics (OpenGL / Nvidia)
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
  # Firewall / Networking (optional)
  ########################################
  # services.openssh.enable = true;
  # networking.firewall.enable = false;

  ########################################
  # System State Version
  ########################################
  system.stateVersion = "25.05"; # Did you read the comment?
}
