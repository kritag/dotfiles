#!/bin/sh
chmod +w /etc/sudoers
echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers
chmod -w /etc/sudoers
