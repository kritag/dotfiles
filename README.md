# dotfiles

Dotbot-managed. Idempotent: re-run `./install` after any change.

Needs: `git`, `bash`, `python3`. Arch: `yay` is bootstrapped by `desktop_arch`.
Fedora: `dnf`.

## Install

`./install [profile...]` runs `default` first, then each profile (name without
`.conf.yaml`). Profiles starting with `server` skip `default`.

```bash
./install                                            # default only
./install workstation_fedora graphical workstation   # Fedora workstation
./install workstation_arch graphical workstation     # Arch workstation
./install desktop_arch graphical desktop             # Arch desktop
```

Profiles: `default` `graphical` `desktop` `desktop_arch` `server_fedora`
`workstation` `workstation_arch` `workstation_fedora`

`graphical` is shared by `desktop` and `workstation`: run it right before the
host profile.

## CachyOS

Installer: **btrfs**, **Limine**. Package page: untick everything except
**Network**: `networkmanager`, `wpa_supplicant`, `wireless-regdb` (the three
from that group I have on Arch). Untick the rest of Network. Everything else is
declared in `desktop_arch`. `python`, `sudo` and `base-devel` are not in any
netinstall group (untested unticked).

First boot: `sudo pacman -S git`, then `./install desktop_arch graphical desktop`.

CachyOS repos come before Arch's in `/etc/pacman.conf` (`cachyos-v3`,
`cachyos-extra-v3`, `cachyos-core-v3`, `cachyos`, then `core`, `extra`,
`multilib`), so same-named packages are CachyOS's x86-64-v3 builds (`dux-gop`,
`mesa`, ...; `dms-shell` is 2.0.0 there vs 1.6.3 in Arch). `downgrade`,
`grimblast-git`, `protonplus`, `zen-browser-bin` and `yay` are prebuilt in the
`cachyos` repo, so `yay -S` takes them from there instead of building the AUR.

## Server

Shared zsh for all users via `/etc/zshrc` → `zsh/server-global.zsh`. Root and
users with their own `~/.zshrc` symlink are skipped.

```bash
sudo mkdir /opt/dotfiles && sudo chown $USER /opt/dotfiles
git clone git@github.com:kritag/dotfiles.git /opt/dotfiles
cd /opt/dotfiles && ./install server_fedora
sudo chsh -s /usr/bin/zsh <user>           # per user; they log in with bash until then
```

Update:

```bash
cd /opt/dotfiles && git pull                       # config only, applies on next shell
cd /opt/dotfiles && git pull && ./install server_fedora   # new packages or links
```

- Per-user links (`server_user.conf.yaml`) apply on a user's first shell and
  after a pull that changes the file.

## Zen

```bash
scripts/zen-link-userjs.sh    # links config/zen/user.js into the active profile
```

## DMS

```bash
scripts/dms-sync.sh desktop workstation   # <from> <to>, shows diff, asks first
```

- Settings per host: `config/dms/settings-{desktop,workstation}.json`. Sync
  before editing on the other host.
- Plugin ids: `bootstrap-dms-plugins.sh` line in the host yaml.
- Desktop autologin: Settings → Greeter → auto login.

## Fingerprint / YubiKey login

```bash
sudo usermod -aG tss $USER                   # re-login after
mkdir -p ~/.config/Yubico && pamu2fcfg -u $USER > ~/.config/Yubico/u2f_keys
pamu2fcfg -n >> ~/.config/Yubico/u2f_keys    # backup key, only it plugged in
ykman config usb --disable OTP
~/.config/hypr/scripts/sealKeyring.sh        # redo after a keyring password change
```

- Lock screen and greeter: Settings → security key. Set
  `lockScreenSecurityKeyShortcut` to `Ctrl+space` in `settings.json`.
- Lock on unplug, `/etc/udev/rules.d/90-yubikey-lock.rules`:

```
ACTION=="remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{PRODUCT}=="1050/*", RUN+="/usr/bin/loginctl lock-sessions"
```

Keyring: don't start `gnome-keyring-daemon` from `autostart.lua` or with
`--replace`. Undo: remove the symlink in `~/.local/share/dbus-1/services/`.

## Private overlay

Fedora workstation runs `scripts/bootstrap-private-overlay.sh`, which runs a
private `bootstrap.sh` from Keybase:

`/run/user/$UID/keybase/kbfs/private/$USER/dotfiles/bootstrap.sh`

Override with env vars: `KEYBASE_MOUNT` `KEYBASE_IDENTITY` `OVERLAY_REL`
`OVERLAY_PATH`
