#!/usr/bin/bash
systemctl --user stop microsoft-identity-broker.service
systemctl --user stop intune-agent.service
systemctl --user stop intune-agent.timer
sudo systemctl stop microsoft-identity-device-broker.service
sudo systemctl stop intune-daemon.socket
rm -rf ~/.cache/intune-portal
rm -rf ~/.local/share/intune-portal
rm -rf ~/.local/state/intune
rm -rf ~/.local/state/microsoft-identity-broker
rm -rf ~/.local/state/log/microsoft-identity-broker
rm -rf ~/.config/microsoft-identity-broker
rm -rf ~/.config/intune
rm -rf ~/.Microsoft ~/.cache/intune-portal ~/.config/intune
rm -rf ~/.cache/microsoft-edge
rm -rf ~/.cache/Microsoft
sudo rm -rf /var/lib/microsoft-identity-device-broker
rm -f ~/.local/state/log/microsoft-identity-broker
