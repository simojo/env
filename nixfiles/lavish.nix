# nonessential packages
{ config, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      unstable.aseprite
      unstable.bitwig-studio
      unstable.discord
      unstable.godot
      unstable.lmms
      unstable.minecraft
      unstable.obs-studio
      unstable.shotcut
      unstable.steam
      unstable.zoom-us
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
