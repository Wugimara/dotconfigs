#!/usr/bin/env bash
ws=$(swaymsg -t get_workspaces | grep -B3 '"focused": true' | head -n1 | awk '{print $2}' | tr -d ',')
col=${ws:0:1}
new=$(( (col - 1 + 1) % 9 + 1 ))  # cycle 1→2→…→9→1
swaymsg workspace ${new}1
