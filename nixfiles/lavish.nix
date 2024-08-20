# nonessential packages
{ config, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      unstable.prismlauncher # used to be multimc
      minecraft
      simplescreenrecorder
      youtube-dl
      prusa-slicer
    ];
  };
}
