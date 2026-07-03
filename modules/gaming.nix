# Gaming config (steam, discord, launchers)
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

  /*
  steam-run ../bx/tools/bin/linux/genie \
  --with-tools --with-combined-examples --with-shared-lib \
  --gcc=linux-gcc \
  gmake
  */
}
