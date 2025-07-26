#!/bin/bash

set -e

echo "==> Installing packages..."
sudo pacman -Sy --noconfirm \
  base-devel git swayfx waybar wofi alacritty \
  mangohud gamemode gamescope \
  brightnessctl pamixer flameshot grim slurp wl-clipboard \
  blueman nm-connection-editor dunst playerctl jq \
  noto-fonts-emoji ttf-jetbrains-mono-nerd ttf-font-awesome \
  rofi

echo "==> Installing latest Swaylock-effects and ProtonGE (optional)..."
yay -S --noconfirm swaylock-effects proton-ge-custom

echo "==> Copying configs..."
cp -r config/* ~/.config/
cp install_swayfx_amd_gaming.sh ~/

echo "==> Applying system tweaks (may require sudo)..."
echo "fs.inotify.max_user_watches=524288" | sudo tee /etc/sysctl.d/99-amd-gaming.conf
echo "fs.file-max=1048576" | sudo tee -a /etc/sysctl.d/99-amd-gaming.conf
echo "vm.max_map_count=1048576" | sudo tee -a /etc/sysctl.d/99-amd-gaming.conf
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/99-amd-gaming.conf

echo 'ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card[0-9]*", RUN+="/usr/bin/sh -c '\''echo performance > /sys/class/drm/%k/device/power_dpm_force_performance_level'\''"' | sudo tee /etc/udev/rules.d/99-amd-performance.rules

echo "==> Done!"
echo "Reboot and launch SwayFX!"