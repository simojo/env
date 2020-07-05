#!/usr/bin/env sh

xrandr \
  --output DP-1 \
  --primary \
  --mode 3840x2160 \
  --rate 60.00 \
  --rotate 'left' \
  --dpi 140 \
  --output DP-2 \
  --mode 3840x2160 \
  --rate 60.00 \
  --rotate 'left' \
  --right-of DP-1 \
  --dpi 140 \
  --output eDP-1 \
  --off

feh --bg-fill /env/imgs/bg/bloom.jpg
bspc wm -r
