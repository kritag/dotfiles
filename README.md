# dotfiles

Modified install script to take .conf.yaml files as arguments. Any number of arguments may be passed depending on the desired installation:
`./install workstation` installs the contents of workstation.conf.yaml.

## Default

Install Brew:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


## Arch

Install yay:

```
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
