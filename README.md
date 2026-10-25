# dotfiles

Personal dotfiles managed with Dotbot and custom plugins.

## Prerequisites

- `git`
- `bash`
- `python3`

Some profiles also rely on package manager plugins:

- Arch: `yay`
- Fedora/RHEL: `yum`/`dnf`

## Install

The installer runs `default.conf.yaml` first, then any profile names you pass
(without the `.conf.yaml` suffix). Server profiles (names starting with `server`)
skip `default`: servers use the shared setup below, with no workstation zsh links.

Examples:

```bash
# Default only
./install

# Workstation profile
./install workstation

# Arch workstation + base workstation
./install workstation_arch workstation

# Fedora workstation + base workstation
./install workstation_fedora workstation
```

Available profiles in this repo:

- `default`
- `desktop`
- `desktop_arch`
- `server_fedora`
- `workstation`
- `workstation_arch`
- `workstation_fedora`

## Server setup

Running `./install server_fedora` installs packages and sets up one shared zsh
for every user: `zsh/server-global.zsh` is hooked into `/etc/zshrc`, so any
interactive zsh (a login shell or `sudo -u immich zsh`) gets the aliases,
keybindings, completion, plugins and the oh-my-posh prompt. Nothing is cloned
per user. Plugins without a Fedora package live in `/opt/zsh-plugins`, pinned to
a tag in `scripts/install-server-zsh.sh`. Users with their own symlinked
`~/.zshrc` (a full dotfiles install) and root keep their own setup.

On a user's first shell, `scripts/bootstrap-server-user.sh` links the shared
eza, bat, btop, fastfetch, lazyvim and zsh-patina config into their `~/.config`
(`server_user.conf.yaml`), using Dotbot. It re-runs by itself after a `git pull`
that changes that file. `sudo` keeps `SSH_CONNECTION`, so a `sudo -u` shell shows
the SSH icon and user name in the prompt.

Users still log in with bash until you switch them: `sudo chsh -s /usr/bin/zsh <user>`.
Service users with a `nologin` shell need nothing.

Clone to `/opt/dotfiles` so the `/etc/zshrc` hook isn't tied to any user's home:

```bash
sudo mkdir /opt/dotfiles && sudo chown $USER /opt/dotfiles
git clone git@github.com:kritag/dotfiles.git /opt/dotfiles
cd /opt/dotfiles
./install server_fedora
```

**Updating config** — just pull, changes take effect on next shell start:
```bash
cd /opt/dotfiles && git pull
```

**New packages or symlinks** — pull and re-run the install:
```bash
cd /opt/dotfiles && git pull && ./install server_fedora
```

Root is excluded automatically — the config skips UID 0.

## Notes

- Desktop and workstation profiles are Hyprland-based.
- Re-run `./install ...` after changes; Dotbot actions are intended to be
  repeatable.

## Zen Browser Profile

Zen prefs are managed as `user.js` in dotfiles and symlinked into the active Zen
profile.

```bash
# Link dotfiles user.js into active Zen profile
scripts/zen-link-userjs.sh
```

Source file:

- `config/zen/user.js`

## DMS

- `config/dms/settings.json`: shared, linked on both hosts. Keep it free of usernames (use `~`).
- One bar for both hosts. Plugin widgets render only where the plugin is installed (`~/.config/dms/plugins/`, not in dotfiles),
  so amdgpu shows on the desktop only.
- Need a real per-host setting: `~/.config/dms/config.d/<host>.json` overrides whole top-level keys (undocumented; `dms restart` once).
- Themes: `scripts/bootstrap-dms-themes.sh` (run by install) downloads them; `themeSwitch.sh` sets theme + fonts.
- Desktop autologin: `scripts/greetd-autologin.sh` (sudo step) writes greetd `[initial_session]`.
  Not DMS's toggle, since the greeter reads the shared `settings.json`. `dms-greeter sync` wipes it: re-run `./install desktop`.

## Login (fingerprint / YubiKey)

```bash
sudo usermod -aG tss $USER                   # re-login after
mkdir -p ~/.config/Yubico && pamu2fcfg -u $USER > ~/.config/Yubico/u2f_keys
pamu2fcfg -n >> ~/.config/Yubico/u2f_keys    # backup key: only it plugged in; joins the same line
ykman config usb --disable OTP               # stops OTP typing on touch
~/.config/hypr/scripts/sealKeyring.sh        # keyring helper; redo after a keyring password change
```

- Keyring: the D-Bus override `services/org.freedesktop.secrets.service` makes activation run `scripts/secretsDaemon.sh`, which starts `gnome-keyring-daemon` already unlocked from the TPM-sealed password (falls back to the stock locked daemon if unsealing fails). `services/unlock-keyring.service` (before keybase) runs `scripts/unlockKeyring.sh` once at login to activate it early. Not in `autostart.lua`, and not `--replace`: replacing the daemon lets D-Bus activate a second, locked one that takes the name. Undo: remove the symlink in `~/.local/share/dbus-1/services/`.
- DMS: Lock Screen → security key, Alternative. UI refuses Space, so set
  `lockScreenSecurityKeyShortcut` to `Ctrl+space` in `settings.json`.
- Greeter: Settings → Greeter → security key; offered after the fingerprint step (~10 s).
- Lock on unplug, `/etc/udev/rules.d/90-yubikey-lock.rules`:

```
ACTION=="remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{PRODUCT}=="1050/*", RUN+="/usr/bin/loginctl lock-sessions"
```

## Private Overlay

Public dotfiles can invoke a private post-install overlay script (for secrets
and company-specific steps) without storing those details in this repo.

Dotbot (Fedora workstation profile) runs:

- `scripts/bootstrap-private-overlay.sh`

Default lookup path:

- `/run/user/$UID/keybase/kbfs/private/$USER/dotfiles/bootstrap.sh`

You can override lookup with env vars:

- `KEYBASE_MOUNT`
- `KEYBASE_IDENTITY`
- `OVERLAY_REL`
- `OVERLAY_PATH`
