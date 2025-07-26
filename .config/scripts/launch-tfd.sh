#!/bin/bash
export MANGOHUD=1
export RADV_PERFTEST=aco
export DXVK_ASYNC=1
export VKD3D_CONFIG=dxr11
export __GL_GSYNC_ALLOWED=1
export __GL_VRR_ALLOWED=1
export MESA_GLTHREAD=1
gamemoderun gamescope -b -w 1920 -h 1080 -W 2560 -H 1440 --scaling FSR --expose-wayland -- steam -applaunch 2074920