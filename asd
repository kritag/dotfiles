whoami; uwsm select 2>/dev/null | head -1; grep -A3 initial_session /etc/greetd/config.toml 
❯ whoami; uwsm select 2>/dev/null | head -1; grep -A3 initial_session /etc/greetd/config.toml
kristian
Could not get terminal width, assuming 128
8:[initial_session]
9-user = "kristian"
10-command = "env XDG_SESSION_TYPE=wayland sh -c 'exec /usr/bin/dms-greeter launch-session --from-memory --cache-dir '\\''/var/cache/dms-greeter'\\'''"
