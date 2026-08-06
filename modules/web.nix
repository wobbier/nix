{ config, lib, pkgs, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = "mitchdandrews@gmail.com";
  };

  # php-fpm for open.mitch.gg
  services.phpfpm.pools.web = {
    user = "nginx";
    group = "nginx";
    settings = {
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "pm" = "dynamic";
      "pm.max_children" = 8;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 4;
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      "nucc.mitch.gg" = {
        serverAliases = [ "mitch.gg" ];
        enableACME = true;
        forceSSL = true;
        root = "/mnt/media/www/nucc.mitch.gg/html";
      };

      # seerr
      "plex.mitch.gg" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5055";
          proxyWebsockets = true;
        };
      };

      # qBittorrent
      "deluge.mitch.gg" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:8080";
      };

      # drumsmith test dlc
      "dlc.mitch.gg" = {
        enableACME = true;
        forceSSL = true;
        root = "/mnt/media/www/dlc.mitch.gg/html";
        locations."/".extraConfig = ''
          autoindex on;
          autoindex_exact_size off;
          autoindex_localtime on;
          add_header 'Access-Control-Allow-Origin' '*';
          add_header 'Access-Control-Allow-Methods' 'GET, OPTIONS';
          add_header 'Access-Control-Allow-Headers' 'Origin, Content-Type, Accept';
        '';
      };

      # barker app
      "barker.mitch.gg" = {
        enableACME = true;
        forceSSL = true;
        root = "/mnt/media/www/barker.mitch.gg/html";
        locations."/".extraConfig = ''
          autoindex on;
          autoindex_exact_size off;
          autoindex_localtime on;
          add_header 'Access-Control-Allow-Origin' '*';
          add_header 'Access-Control-Allow-Methods' 'GET, OPTIONS';
          add_header 'Access-Control-Allow-Headers' 'Origin, Content-Type, Accept';
        '';
      };

      # raw file shit
      "open.mitch.gg" = {
        enableACME = true;
        forceSSL = true;
        root = "/mnt/media/www/open.mitch.gg/html";
        locations."= /".extraConfig = ''
          index index.php;
        '';
        locations."/".extraConfig = ''
          autoindex on;
          try_files $uri $uri/ /index.php?$args;
        '';
        locations."~ \\.php$".extraConfig = ''
          include ${config.services.nginx.package}/conf/fastcgi.conf;
          fastcgi_pass unix:${config.services.phpfpm.pools.web.socket};
        '';
        locations."~ /\\.ht".extraConfig = ''
          deny all;
        '';
      };
    };
  };
}
