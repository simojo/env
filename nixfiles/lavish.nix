# nonessential packages
{ config, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      unstable.prismlauncher # used to be multimc
      simplescreenrecorder
      youtube-dl
    ];
  };
}
