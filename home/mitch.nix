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
  ];

  home.activation.mySymlinks = lib.mkAfter ''
    rm -rf ${config.home.homeDirectory}/.config/hypr
    ln -sfn ${config.home.homeDirectory}/nix/hypr ${config.home.homeDirectory}/.config/hypr

    rm -rf ${config.home.homeDirectory}/.config/wallust
    ln -sfn ${config.home.homeDirectory}/nix/config/wallust ${config.home.homeDirectory}/.config/wallust

    rm -rf ${config.home.homeDirectory}/.config/waybar
    ln -sfn ${config.home.homeDirectory}/nix/config/waybar ${config.home.homeDirectory}/.config/waybar

    rm -rf ${config.home.homeDirectory}/.config/rofi
    ln -sfn ${config.home.homeDirectory}/nix/config/rofi ${config.home.homeDirectory}/.config/rofi

    rm -rf ${config.home.homeDirectory}/.config/kitty
    ln -sfn ${config.home.homeDirectory}/nix/config/kitty ${config.home.homeDirectory}/.config/kitty

    rm -rf ${config.home.homeDirectory}/.config/btop
    ln -sfn ${config.home.homeDirectory}/nix/config/btop ${config.home.homeDirectory}/.config/btop
  '';

  xdg.configFile."mako/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/config/mako/config";

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
