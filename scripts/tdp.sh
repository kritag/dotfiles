#!/usr/bin/env bash
# Power/clock/fan tuning for the 7800XT. Re-runs itself under sudo.
set -euo pipefail
[[ $EUID -eq 0 ]] || exec sudo "$0" "$@"

PL=265        # W | 265 default
SCLK_MAX=2565 # MHz | 2565 default
MCLK_MAX=1220 # MHz | 1220 default
VOLT_OFF=0    # mV | 0 default

# the card exposing the overdrive interface (skips an iGPU)
dev=
for d in /sys/class/drm/card*/device; do
  [[ -e $d/pp_od_clk_voltage ]] && dev=$d && break
done
[[ -n $dev ]] || { echo "no AMD GPU with overdrive found" >&2; exit 1; }

od="$dev/pp_od_clk_voltage"
fan="$dev/gpu_od/fan_ctrl/fan_curve"
w() { printf '%s\n' "$1" >"$2"; }

# set power limit
for cap in "$dev"/hwmon/*/power1_cap; do w "$((PL * 10 ** 6))" "$cap"; done

# set power profile
w manual "$dev/power_dpm_force_performance_level"
w 1 "$dev/pp_power_profile_mode"

# set clocks and voltage
w "s 1 $SCLK_MAX" "$od"
w "s 0 $SCLK_MAX" "$od"
w "m 1 $MCLK_MAX" "$od"
w "vo $VOLT_OFF" "$od"

# set fan curve (point | temp | fan %)
w "0 25 30" "$fan"
w "1 54 32" "$fan"
w "2 56 34" "$fan"
w "3 58 36" "$fan"
w "4 60 38" "$fan"

# commit all settings
w c "$od"
w c "$fan"
