#!/bin/bash
swayidle -w \
  timeout 300 'swaylock -f --effect-blur 7x5 --effect-vignette 0.5:0.5' \
  timeout 600 'swaymsg "output * dpms off"' \
  resume 'swaymsg "output * dpms on"' \
  before-sleep 'swaylock -f --effect-blur 7x5 --effect-vignette 0.5:0.5'