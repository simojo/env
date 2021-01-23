{ config, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      unstable.aseprite
      unstable.discord
      unstable.godot
      unstable.lmms
      unstable.minecraft
      unstable.shotcut
      unstable.steam
      unstable.zoom-us
      youtube-dl
    ];
  };
}
