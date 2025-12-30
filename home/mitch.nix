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
  '';

  xdg.configFile."mako/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/config/mako/config";

  xdg.configFile."wofi/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/config/wofi/config";

  xdg.configFile."wofi/style.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/config/wofi/style.css";

  # Shell
  programs.bash.enable = true;
  # programs.zsh.enable = true;
  programs.kitty.enable = true;
}
