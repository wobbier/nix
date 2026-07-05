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
  # Everything that touches media files runs in the "media" group;
  # media dirs should be group-owned (chgrp -R media, g+rw, dirs g+s).
  users.groups.media = { };
  users.users.mitch.extraGroups = [ "media" ];

  # Media storage — uncomment and fill in the UUID when this config runs on
  # real hardware (find it with: lsblk -f).
  # For ext4/xfs, group ownership lives on the filesystem itself — do the
  # one-time `chgrp -R media` / `chmod g+rws` dance after the first mount.
  # For NTFS/exFAT there are no Linux owners on disk, so set them at mount
  # time instead: add "uid=1000" and "gid=media"-equivalent gid to options.
  #fileSystems."/mnt/media" = {
  #  device = "/dev/disk/by-uuid/XXXX-XXXX";
  #  fsType = "ext4";
  #  options = [ "nofail" ]; # mount at boot, but don't block boot if missing
  #};

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

  services.seerr.enable = true;

  virtualisation.docker.enable = true;

  # Web / reverse proxy for the *.mitch.gg subdomains
  # (radarr's 7878 and plex's 32400 are opened by their openFirewall options)
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
