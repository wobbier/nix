{ config, pkgs, ... }:

{
  ########################################
  # User: mitch
  ########################################
  users.users.mitch = {
    isNormalUser = true;
    description = "Mitch Andrews";
    extraGroups = [ "networkmanager" "wheel" ];

    # Per-user GUI / dev tools (can move to Home Manager later)
    packages = with pkgs; [
      #kdePackages.kate
    ];
  };
}
