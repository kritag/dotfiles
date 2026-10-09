#!/usr/bin/env python3
"""Flavours hook: replace @mix:<bg>:<fg>:<pct>@ tokens in the delta theme with blended hex colors."""
import os
import re

PATH = os.path.realpath(os.path.expanduser("~/.theme.gitconfig"))


def mix(bg, fg, pct):
    a, b = (tuple(int(c[i : i + 2], 16) for i in (0, 2, 4)) for c in (bg, fg))
    return "#" + "".join(f"{round(x + (y - x) * pct / 100):02x}" for x, y in zip(a, b))


with open(PATH) as f:
    text = f.read()

text = re.sub(
    r"@mix:([0-9a-fA-F]{6}):([0-9a-fA-F]{6}):(\d+)@",
    lambda m: mix(m[1], m[2], int(m[3])),
    text,
)

with open(PATH, "w") as f:
    f.write(text.rstrip("\n") + "\n")
