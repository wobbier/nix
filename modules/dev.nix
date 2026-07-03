# Development / gamedev tooling
{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # dev
    renderdoc
    dotnet-sdk
    autoconf
    cmakeWithGui
    blender
    jetbrains.clion
    bear
    gnumake
    gcc
    gdb

    # gamedev
    unityhub
    godot-mono
    unrar
  ];
}
