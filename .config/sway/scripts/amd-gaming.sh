#!/bin/bash
echo "performance" | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level
echo "1" | sudo tee /sys/class/drm/card0/device/variable_refresh
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo performance | sudo tee $cpu
done
export __GL_GSYNC_ALLOWED=1
export __GL_VRR_ALLOWED=1
export RADV_PERFTEST=aco
export DXVK_ASYNC=1
export MESA_GLTHREAD=1
export WINE_FULLSCREEN_FSR=1
export WINE_FULLSCREEN_FSR_STRENGTH=5