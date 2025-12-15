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
  '';

  xdg.configFile."waybar/config.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/config/waybar/config.jsonc";

  xdg.configFile."waybar/style.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/config/waybar/style.css";


  # Example shell config you can expand later
  programs.bash.enable = true;
  # programs.zsh.enable = true;
  programs.kitty.enable = true;
}
