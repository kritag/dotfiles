#!/bin/bash
mkdir -p ~/.local/share/icons/default
touch ~/.local/share/icons/default/index.theme
cat << EOF > ~/.local/share/icons/default/index.theme
[Icon Theme]
Inherits=Dracula-cursors
EOF

