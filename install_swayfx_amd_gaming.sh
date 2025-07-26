#!/bin/bash

set -e


echo "==> aur and grub..."
### cachyos-repo
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh

### chaotic-aur
# Add chaotic AUR keys and repository if not added, else skip
echo "Adding chaotic AUR keys and repository"
if ! pacman-key --list-keys chaotic-aur &> /dev/null; then
  echo "Adding chaotic AUR keys and repository"
  sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key 3056513887B78AEB
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
  echo "Chaotic AUR keys added successfully"
else
  echo "Chaotic AUR keys and repository already added. Skipping..."
fi

# Add chaotic AUR
if ! grep -q "^\[chaotic-aur\]" /etc/pacman.conf; then
  echo "[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
  sudo pacman -Sy
  echo "Chaotic AUR repository added/updated successfully"
fi

sudo pacman -Syu

echo "Setting up GRUB..."
BACKUP="/etc/default/grub.bak.$(date +%F-%T)"
GRUB_CFG="/etc/default/grub"

echo "Backing up current GRUB config to $BACKUP"
sudo cp "$GRUB_CFG" "$BACKUP"

# Detect swap UUID for resume param
SWAP_UUID=$(blkid -t TYPE=swap -o value -s UUID)
if [ -z "$SWAP_UUID" ]; then
  echo "⚠️ No swap partition UUID found. Skipping resume parameter."
  RESUME_PARAM=""
else
  RESUME_PARAM="resume=UUID=$SWAP_UUID"
fi

# New kernel parameters
NEW_PARAMS="quiet splash amdgpu.dc=1 amdgpu.enable_fsync=1 amdgpu.async_flip=1 mitigations=off zswap.enabled=1 $RESUME_PARAM"

echo "Setting GRUB_CMDLINE_LINUX_DEFAULT kernel params to:"
echo "  $NEW_PARAMS"

sudo sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=3/" "$GRUB_CFG"

if grep -q "^GRUB_CMDLINE_LINUX_DEFAULT=" "$GRUB_CFG"; then
  sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_PARAMS\"|" "$GRUB_CFG"
else
  echo "GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_PARAMS\"" | sudo tee -a "$GRUB_CFG"
fi

if ! grep -q "^GRUB_CMDLINE_LINUX=" "$GRUB_CFG"; then
  echo 'GRUB_CMDLINE_LINUX=""' | sudo tee -a "$GRUB_CFG"
fi

echo "Updating GRUB configuration..."

if [ -d /sys/firmware/efi ]; then
  sudo grub-mkconfig -o /boot/efi/EFI/arch/grub.cfg
else
  sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

echo -e "\n✅ GRUB tweaks applied! Reboot your system to take effect."

###### paru and yay ########
sudo pacman -Sy --noconfirm yay paru

echo "==> Installing packages..."
yay -Sy --noconfirm \
  base-devel git swayfx waybar wofi alacritty \
  mangohud gamemode kitty thunar xfce4-terminal gamescope \
  brightnessctl wofi pamixer flameshot grim slurp wl-clipboard \
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
