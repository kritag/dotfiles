# dotfiles

Modified install script to take .conf.yaml files as arguments. Any number of arguments may be passed depending on the desired installation:
`./install workstation` installs the contents of workstation.conf.yaml.

## Non-arch

Install Brew:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


## Arch

- Install yay:

```
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
- Run ./install (machine)_arch.conf.yaml (machine).conf.yaml

- Uncomment PowerKey etc. in `/etc/systemd/logind.conf` 
- Set MaxFileSec=1week in `/etc/systemd/journald.conf` 
- Set `deny = 0` in `/etc/security/faillock.conf`
- Set servers in `/etc/pacman.d/mirrorlist`
- Uncomment LogFile, Color, ParallelDownloads and ILoveCandy in `/etc/pacman.conf`
  - Include multilib
- Configure timeshift autosnap
- Run `fc-cache -fv`
