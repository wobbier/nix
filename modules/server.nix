{ config, lib, pkgs, inputs, ... }:

{
  services.flatpak.enable = true;

  ########################################
  # Remote desktop
  ########################################
  # wayvnc listens on localhost only (VNC is unencrypted); connect with:
  #   ssh -L 5900:localhost:5900 <server>   then point a VNC client at localhost:5900
  services.displayManager.gdm.enable = lib.mkForce false;
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "start-hyprland";
      user = "mitch";
    };
  };
  environment.systemPackages = [ pkgs.wayvnc ];

  ########################################
  # Media stack
  ########################################
  
  users.groups.media = { };
  users.users.mitch.extraGroups = [ "media" ];

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/28196776-89a3-4999-af3d-596c48a7a57b";
    fsType = "ext4";
    options = [ "nofail" ]; # mount at boot, but don't block boot if missing
  };

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
    torrentingPort = 49160;
  };

  systemd.services.qbittorrent.serviceConfig.UMask = "0002";
  systemd.services.sonarr.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.radarr.serviceConfig.UMask = lib.mkForce "0002";

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.flaresolverr = {
    enable = true;
  };

  services.seerr.enable = true;

  virtualisation.docker.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 32400 ];
  networking.firewall.allowedUDPPorts = [ 49160 ];
}
