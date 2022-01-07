# nonessential packages
{ config, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      unstable.mplayer
      unstable.multimc
      simplescreenrecorder
      youtube-dl
    ];
  };
}
