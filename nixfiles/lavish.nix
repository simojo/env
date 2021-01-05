{ config, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      unstable.aseprite
      unstable.discord
      unstable.godot
      unstable.minecraft
      unstable.zoom-us
      unstable.steam
      youtube-dl
    ];
  };
}
