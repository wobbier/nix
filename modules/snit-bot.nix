{ config, lib, pkgs, ... }:

{
  systemd.services.snit-bot = {
    description = "Snit Discord bot";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      User = "mitch";
      Group = "users";
      WorkingDirectory = "/home/mitch/Projects/snit-bot";
      ExecStart = "${pkgs.nodejs}/bin/node app.js";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
