# nonessential packages
{ config, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      unstable.ardour
      unstable.arduino-cli
      unstable.aseprite
      unstable.bitwig-studio
      unstable.discord
      unstable.godot
      unstable.mplayer
      unstable.multimc
      unstable.lmms
      unstable.reaper
      unstable.shotcut
      unstable.slack-dark
      thonny
      unstable.steam
      unstable.zoom-us
      rshell
      simplescreenrecorder
      youtube-dl
    ];
  };

  # NOTE: this does not work
  # programs.steam.enable = true;

  hardware = {
    steam-hardware.enable = true;
    opengl = {
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      driSupport32Bit = true;
    };
  };
}
