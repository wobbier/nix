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
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # User-level packages (we'll start light; you can move more here later)
  home.packages = with pkgs; [
    htop
    btop
  ];

  # Example shell config you can expand later
  programs.bash.enable = true;
  # programs.zsh.enable = true;
  programs.kitty.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 32;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
  wayland.windowManager.hyprland.settings = {
    monitor = "DP-2, 5120x1440@239.76Hz, 0x0, 1";
    "$mod" = "SUPER";
    bind =
      [
        "$mod, F, exec, chrome"
        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
  };

}
