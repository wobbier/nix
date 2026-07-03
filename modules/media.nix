# Media / desktop apps
{ config, pkgs, inputs, ... }:

{
  programs.thunderbird.enable = true;

  programs.spicetify =
  let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in
  {
    enable = true;
    theme = spicePkgs.themes.defaultDynamic;
  };

  environment.systemPackages = with pkgs; [
    audacity
    plex-desktop
    bitwig-studio6
  ];
}
