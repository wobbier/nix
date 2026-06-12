# modules/odysseus.nix
{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings.features.cdi = true;

  # Generates CDI spec at /run/cdi/nvidia-container-toolkit.json
  hardware.nvidia-container-toolkit.enable = true;

  users.users.mitch.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    git
    docker-compose
  ];

  environment.etc."odysseus/cuda-symlink.patch".source = ./odysseus-cuda-symlink.patch;

  # Compose overlay that passes the NVIDIA GPU via CDI (driver: nvidia breaks on
  # NixOS because nvidia-container-runtime can't locate runc at standard paths).
  environment.etc."odysseus/gpu.cdi.yml".text = ''
    services:
      odysseus:
        environment:
          - NVIDIA_VISIBLE_DEVICES=all
          - NVIDIA_DRIVER_CAPABILITIES=compute,utility
        devices:
          - "nvidia.com/gpu=all"
  '';

  systemd.services.odysseus = {
    description = "Odysseus Docker Compose app";

    wantedBy = [ "multi-user.target" ];
    requires = [ "docker.service" ];
    wants = [ "network-online.target" ];
    after = [ "docker.service" "network-online.target" ];

    path = with pkgs; [
      git
      patch
      docker
      docker-compose
      coreutils
      bash
    ];

    environment = {
      COMPOSE_FILE = "docker-compose.yml:/etc/odysseus/gpu.cdi.yml";
    };

    restartIfChanged = true;

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/srv";
    };

    preStart = ''
      set -euo pipefail

      mkdir -p /srv

      if [ ! -d /srv/odysseus/.git ]; then
        rm -rf /srv/odysseus
        git clone https://github.com/pewdiepie-archdaemon/odysseus.git /srv/odysseus
      else
        git -C /srv/odysseus checkout routes/cookbook_helpers.py
        git -C /srv/odysseus pull --ff-only
      fi
      patch -N -p1 -d /srv/odysseus < /etc/odysseus/cuda-symlink.patch || true

      if [ ! -f /srv/odysseus/.env ] && [ -f /srv/odysseus/.env.example ]; then
        cp /srv/odysseus/.env.example /srv/odysseus/.env
      fi
    '';

    script = ''
      set -euo pipefail
      cd /srv/odysseus

      docker compose pull || true
      docker compose build --pull
      docker compose up -d
    '';

    preStop = ''
      cd /srv/odysseus
      docker compose down
    '';
  };
}
