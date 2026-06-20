{ config, pkgs, lib, ... }:

{
  ########################################
  # Home Manager: mitch
  ########################################

  home.username = "mitch";
  home.homeDirectory = "/home/mitch";

  # Version of Home Manager's state. Stick to when you first enable it.
  home.stateVersion = "25.05";

  # Enable the `home-manager` command for this user.
  programs.home-manager.enable = true;

  # User-level packages (we'll start light; you can move more here later)
  home.packages = with pkgs; [
    htop
    btop

    ( pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    } )
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Mitch Andrews";
        email = "rastaninja77@gmail.com";
      };
    };
  };


  xdg.configFile =
    let
      link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${path}";
    in
    {
      "hypr".source        = link "nix/hypr";
      "wallust".source     = link "nix/config/wallust";
      "waybar".source      = link "nix/config/waybar";
      "rofi".source        = link "nix/config/rofi";
      "kitty".source       = link "nix/config/kitty";
      "btop".source        = link "nix/config/btop";
      "wlogout".source     = link "nix/config/wlogout";
      "mako/config".source = link "nix/config/mako/config";
    };

  # Shell
  programs.ssh = {
    matchBlocks."*" = {
      extraOptions.IdentityAgent = "~/.1password/agent.sock";
    };
  };
  programs.bash.enable = true;
  # programs.zsh.enable = true;
  # programs.kitty.enable = true; # so this removes my shit cause it's in home, move my dotfiles to here
  services.gammastep = {
    enable = true;

    dawnTime = "6:00-7:45";
    duskTime = "18:35-20:15";

    temperature = {
      day = 5500;
      night = 2500;
    };

    tray = true;
    enableVerboseLogging = true;

    settings = {
      general = {
        adjustment-method = "wayland";
        location-provider = "manual";
      };

      manual = {
        lat = 43.6532;
        lon = -79.3832;
      };
    };
  };
}
