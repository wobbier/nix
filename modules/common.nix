# Common configuration shared by all machines (desktop + laptop)
{ config, pkgs, inputs, ... }:

{

  ########################################
  # Networking
  ########################################
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
  services.displayManager.gdm.enable = true;

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
  # Printing
  ########################################
  services.printing.enable = true;

  ########################################
  # Audio
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
  # Login / Session
  ########################################
  services.displayManager.autoLogin.enable = false;

  # Electron flags
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Exported for hyprland.conf
  environment.sessionVariables.HOSTNAME = config.networking.hostName;

  ########################################
  # Core Programs
  ########################################

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

  services.openssh.enable = true;

  # Open With Fix
  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  ########################################
  # System Packages
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

    # power menu
    wlogout

    # utilities
    sbctl
    grim slurp wl-clipboard
    rofi
    p7zip
    hyprpolkitagent
    emote
    fastfetch
    wlvncc
    caligula # iso burning
    claude-code
    wf-recorder

    # media
    vlc
    ffmpeg-full

    # dev
    vscode-fhs
    nodejs
    python3

    # web browser
    google-chrome

    # virt
    virtiofsd

    # rice
    awww
  ];

  ########################################
  # Screen Sharing
  ########################################
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];

    config = {
      common = {
        default = [ "hyprland" ];
      };
    };
  };

  ########################################
  # Virtualisation
  ########################################
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
  programs.virt-manager.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  ########################################
  # Security
  ########################################
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  networking.extraHosts = ''
    192.168.18.16 nucc
    192.168.18.16 deluge.mitch.gg
    192.168.18.16 plex.mitch.gg
    192.168.18.16 open.mitch.gg
    192.168.18.16 dlc.mitch.gg
  '';

  networking.firewall.allowedTCPPorts = [ 53317 ]; # localsend
  networking.firewall.allowedUDPPorts = [ 53317 ]; # localsend
}
