{ config, pkgs, inputs, ... }:

{
  services.openssh.enable = true;
  services.flatpak.enable = true;

  services.seerr.enable = true;

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
  };

  services.flaresolverr = {
    enable = true;
  };

  ########################################
  # System Packages (shared)
  ########################################

  environment.systemPackages = with pkgs; [
    nodejs
    python3

    # plex
    sonarr
    qbittorrent
    prowlarr
  ];
  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.mitch.extraGroups = [ "libvirtd" "kvm" ];
}
