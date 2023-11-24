#!/bin/sh
usermod -aG docker $SUDO_USER && newgrp docker
