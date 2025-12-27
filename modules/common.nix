# Common configuration shared by all machines (desktop + laptop)
{ config, pkgs, ... }:

{
  ########################################
  # Imports (shared users, etc.)
  ########################################
  imports = [
    ../users/mitch.nix
  ];

  ########################################
  # Networking (shared defaults)
  ########################################
  # Hostname is host-specific; set that in hosts/*/configuration.nix
  networking.networkmanager.enable = true;

  ########################################
  # Locale & Time (shared)
  ########################################
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  ########################################
  # Display Server / Desktop Environments (shared)
  ########################################
  services.xserver.enable = true;

  # Display Manager
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  # Desktop Environments
  services.desktopManager.plasma6 = {
    enable = true;
  };
  services.displayManager.defaultSession = "hyprland";
  # services.xserver.desktopManager.gnome.enable = true;

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  ########################################
  # Printing (shared)
  ########################################
  services.printing.enable = true;

  ########################################
  # Audio (PipeWire) (shared)
  ########################################
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  ########################################
  # Login / Session (shared)
  ########################################
  services.displayManager.autoLogin.enable = false;
  # Electron flags
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  ########################################
  # Core Programs (shared)
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
  # System Packages (shared)
  ########################################
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # essentials
    vim
    git
    vscode-fhs
    hyprpaper
    wallust
    nerd-fonts.jetbrains-mono

    # notifications
    mako

    # login screen
    swaylock

    # utilities
    sbctl
    discord
    mangohud
    grim slurp wl-clipboard
    wofi
    p7zip
    hyprpolkitagent
    emote
    fastfetch

    # media
    obs-studio
    vlc
    audacity
    spotify

    # dev
    nodejs
    python3
    renderdoc
    dotnet-sdk
    gnumake
    libgcc
    gcc
    zlib
    smartgit
    steam-run
    autoconf
    cmakeWithGui

    # gamedev
    unityhub
    
    # engine dev
    # bgfx
    libGLU # is this needed from having libGL?
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXxf86vm
    xorg.libXfixes
    xorg.libxcb
    xorg.xorgproto
    vulkan-loader
    vulkan-headers
    pkg-config

    #SDL -- move to own flake?
    SDL2
    wayland
    wayland-protocols
    wayland-scanner
    libxkbcommon
    libGL
    mesa
    libdrm

    alsa-lib
    pulseaudio
    pipewire
    jack2

    # gaming
    steam
    lutris
    wowup-cf
    runescape
    runelite

    # web browser
    google-chrome
    bottles-unwrapped
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  ########################################
  # Security
  ########################################
  security.pam.services.sddm.enableKwallet = true;

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
  /*
  steam-run ../bx/tools/bin/linux/genie \
  --with-tools --with-combined-examples --with-shared-lib \
  --gcc=linux-gcc \
  gmake
  */
}
