{ config, pkgs, inputs, ... }:

{
  services.flatpak.enable = true;

  services.seerr.enable = true;

  ########################################
  # Media stack
  ########################################
  # Everything that touches media files runs in the "media" group;
  # media dirs should be group-owned (chgrp -R media, g+rw, dirs g+s).
  users.groups.media = { };
  users.users.mitch.extraGroups = [ "media" ];

  services.plex = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.flaresolverr = {
    enable = true;
  };

  virtualisation.docker.enable = true;

  # Web / reverse proxy for the *.mitch.gg subdomains
  # (radarr's 7878 and plex's 32400 are opened by their openFirewall options)
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
