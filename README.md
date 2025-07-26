# SwayFX AMD Gaming Dotfiles

Optimized configs and scripts for a SwayFX gaming environment on AMD hardware.

---

## Quick Start

```sh
git clone https://github.com/CrowdRocker/swayfx-amd-gaming.git
cd swayfx-amd-gaming
chmod +x install_swayfx_amd_gaming.sh
./install_swayfx_amd_gaming.sh
```

---

## Structure

- `install_swayfx_amd_gaming.sh` – automated install and setup
- `config/` – all configs:
    - `sway/` – SwayFX config and themes
    - `waybar/` – Waybar config, style, scripts, custom modules
    - `wofi/` – Wofi config and style
    - `environment.d/` – AMD gaming environment variables
    - `scripts/` – Game launchers, mod loader, power menu, etc.

---

## Customization

- Edit configs in the `config/` folder before running the install script, or after installation in `~/.config/`.
- Update game launchers in `config/scripts/`.
- For weather, set your API key in `config/waybar/scripts/weather.sh`.

---

## Updating

Make changes locally, then:

```sh
git add .
git commit -m "Describe your changes"
git push
```
