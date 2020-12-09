{ config, lib, pkgs, ... }:
{
  environment = {
    systemPackages = [
      pkgs.aseprite
      pkgs.discord
      pkgs.godot
      pkgs.minecraft
      pkgs.spotify-tui
      pkgs.youtube-dl
      pkgs.zoom-us
    ];
  };
}
