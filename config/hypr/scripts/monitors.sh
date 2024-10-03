#! /bin/bash

# This script turns off the laptop screen if an external display is connected
# You can change the monitor names to whatever you want (hyprctl monitors to list the outputs)

if [ $(hyprctl monitors | grep Monitor | wc -l) -ge 2 ]; then
  hyprctl keyword monitor eDP-1,disable
  hyprctl keyword monitor HDMI-A-1,highrr,0x0,1
else
  hyprctl keyword monitor eDP-1,preferred,0x0,1
  hyprctl keyword monitor HDMI-A-1,disable
fi
