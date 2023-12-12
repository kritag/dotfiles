# dotfiles
Modified install script to take .conf.yaml files as arguments. Any number of arguments may be passed depending on the desired installation:
`./install workstation` installs the contents of workstation.conf.yaml.

## Default
Install Brew:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Install Lunarvim:
https://www.lunarvim.org/docs/installation
```
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
```

## Arch:
Install yay:
```
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
