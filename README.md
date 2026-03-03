# dotfiles

Personal dotfiles managed with Dotbot and custom plugins.

## Prerequisites

- `git`
- `bash`
- `python3`

Some profiles also rely on package manager plugins:

- Arch: `yay`
- Fedora/RHEL: `yum`/`dnf`
- macOS/Linux (non-Arch): `brew`

## Install

The installer always runs `default.conf.yaml` first, then any profile names you
pass (without the `.conf.yaml` suffix).

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
- `server`
- `server_fedora`
- `workstation`
- `workstation_arch`
- `workstation_fedora`

## Notes

- Desktop and workstation profiles are Hyprland-based.
- Re-run `./install ...` after changes; Dotbot actions are intended to be
  repeatable.

## Zen Browser Profile

Zen prefs are managed as `user.js` in dotfiles and symlinked into the active Zen
profile.

```bash
# Link dotfiles user.js into active Zen profile
scripts/zen-link-userjs
```

Source file:

- `config/zen/user.js`

## Private Overlay

Public dotfiles can invoke a private post-install overlay script (for secrets
and company-specific steps) without storing those details in this repo.

Dotbot (Fedora workstation profile) runs:

- `scripts/bootstrap-private-overlay`

Default lookup path:

- `/run/user/$UID/keybase/kbfs/private/$USER/dotfiles/bootstrap.sh`

You can override lookup with env vars:

- `KEYBASE_MOUNT`
- `KEYBASE_IDENTITY`
- `OVERLAY_REL`
- `OVERLAY_PATH`
