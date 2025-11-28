{ config, pkgs, ... }:

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

  # Example shell config you can expand later
  programs.bash.enable = true;
  # programs.zsh.enable = true;
}
