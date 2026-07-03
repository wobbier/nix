# Common configuration shared by all machines (desktop + laptop)
{ config, pkgs, inputs, ... }:

{
  programs.steam.enable = true;
  services.flatpak.enable = true;

  #programs.vesktop = { #home config?
  #  enable = true;
  #  settings = {
  #    splashTheming = false;
  #    staticTitle = true;
  #    hardwareAcceleration = true;
  #    discordBranch = "stable";
  #  };
  #};
  
  ########################################
  # System Packages (shared)
  ########################################

  environment.systemPackages = with pkgs; [
    # utilities
    mangohud

    # media
    obs-studio
    discord-ptb
    vesktop #discord client

    # gaming
    #lutris
    wowup-cf # remove once I get my archon flake added to this file
    bolt-launcher # runescape

    #bottles-unwrapped
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  /*
  steam-run ../bx/tools/bin/linux/genie \
  --with-tools --with-combined-examples --with-shared-lib \
  --gcc=linux-gcc \
  gmake
  */
}
