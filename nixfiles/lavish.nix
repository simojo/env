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
      unstable.zoom-us
      unstable.steam
      youtube-dl
    ];
  };
  # FIXME: this does not work
  # programs.steam.enable = true;
  hardware = {
    steam-hardware.enable = true;
    opengl = {
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      driSupport32Bit = true;
    };
  };
}
