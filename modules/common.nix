# Common configuration shared by all machines (desktop + laptop)
{ config, pkgs, inputs, ... }:

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
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;

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
    audio.enable = true;
    alsa.enable = true;
    jack.enable = true;
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

  programs.thunderbird.enable = true;

  services.openssh.enable = true;
  services.flatpak.enable = true;

  programs.spicetify =
  let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in
  {
    enable = true;
    theme = spicePkgs.themes.defaultDynamic;
  };

  ########################################
  # System Packages (shared)
  ########################################
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # essentials
    vim
    lazygit
    fzf
    ripgrep
    wallust
    nerd-fonts.jetbrains-mono
    libnotify
    kitty
    gammastep
    flameshot
    hyprpicker
    localsend

    # audio
    pavucontrol
    pamixer
    playerctl

    # notifications
    mako

    # lock screen
    wlogout
    hyprlock

    # utilities
    sbctl
    discord
    mangohud
    grim slurp wl-clipboard
    rofi
    p7zip
    hyprpolkitagent
    emote
    fastfetch
    wlvncc
    caligula # iso burning

    # media
    obs-studio
    vlc
    audacity
    plex-desktop

    # dev
    vscode-fhs
    nodejs
    python3
    renderdoc
    dotnet-sdk
    gnumake
    gcc
    autoconf
    cmakeWithGui
    blender

    # gamedev
    unityhub

    # gaming
    steam
    #lutris
    wowup-cf
    bolt-launcher # runescape

    # web browser
    google-chrome
    #bottles-unwrapped

    # work
    openconnect
    openconnect_openssl
    parsec-bin
    slack

    # rice
    swww # swap to awww when you flake your shit
  ];

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.mitch.extraGroups = [ "libvirtd" "kvm" ];

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

  networking.extraHosts = ''
    10.88.111.20 nucc
    10.88.111.20 deluge.mitch.gg
    10.88.111.20 plex.mitch.gg
    10.88.111.20 open.mitch.gg
  '';
  
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];

  /*
  steam-run ../bx/tools/bin/linux/genie \
  --with-tools --with-combined-examples --with-shared-lib \
  --gcc=linux-gcc \
  gmake
  */
}
