#!/bin/bash
GAME_EXEC="$1"
shift
if [ -n "$1" ]; then
  MOD_LOADER="$1"
  shift
  echo "Launching mod loader: $MOD_LOADER $*"
  "$MOD_LOADER" "$@"
  sleep 2
fi
export MANGOHUD=1
export RADV_PERFTEST=aco
export DXVK_ASYNC=1
export VKD3D_CONFIG=dxr11
export __GL_GSYNC_ALLOWED=1
export __GL_VRR_ALLOWED=1
export MESA_GLTHREAD=1
gamemoderun gamescope -b -w 1920 -h 1080 -W 2560 -H 1440 --scaling FSR --expose-wayland -- "$GAME_EXEC"