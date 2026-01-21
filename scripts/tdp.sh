#!/usr/bin/bash
#!/usr/bin/env bash

# 7800XT

PL=265 # W | 265 default
SCLK_MAX=2565 # MHz | 2565 default
MCLK_MAX=1220 # MHz | 1220 default
VOLT_OFF=0 # mV | 0 default

# set power limit
sudo bash -c "echo '$((PL * 10**6))' > /sys/class/drm/card*/device/hwmon/*/power1_cap"

# set power profile
sudo bash -c "echo 'manual' > /sys/class/drm/card*/device/power_dpm_force_performance_level"
sudo bash -c "echo '1' > /sys/class/drm/card*/device/pp_power_profile_mode"

# set clocks and voltage
sudo bash -c "echo 's 1 $SCLK_MAX' > /sys/class/drm/card*/device/pp_od_clk_voltage"
sudo bash -c "echo 's 0 $SCLK_MAX' > /sys/class/drm/card*/device/pp_od_clk_voltage"
sudo bash -c "echo 'm 1 $MCLK_MAX' > /sys/class/drm/card*/device/pp_od_clk_voltage"
sudo bash -c "echo 'vo $VOLT_OFF' > /sys/class/drm/card*/device/pp_od_clk_voltage"

# set fan curve (temp | fan %)
sudo bash -c "echo '0 25 30' > /sys/class/drm/card*/device/gpu_od/fan_ctrl/fan_curve"
sudo bash -c "echo '1 54 32' > /sys/class/drm/card*/device/gpu_od/fan_ctrl/fan_curve"
sudo bash -c "echo '2 56 34' > /sys/class/drm/card*/device/gpu_od/fan_ctrl/fan_curve"
sudo bash -c "echo '3 58 36' > /sys/class/drm/card*/device/gpu_od/fan_ctrl/fan_curve"
sudo bash -c "echo '4 60 38' > /sys/class/drm/card*/device/gpu_od/fan_ctrl/fan_curve"

# commit all settings
sudo bash -c "echo 'c'| tee /sys/class/drm/card*/device/pp_od_clk_voltage | tee /sys/class/drm/card*/device/gpu_od/fan_ctrl/fan_curve 1>/dev/null"
