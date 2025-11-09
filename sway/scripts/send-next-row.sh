#!/usr/bin/env bash
workspace=$(swaymsg -t get_workspaces | grep -B3 '"focused": true,' | head -n1 | awk '{print $2}' | tr -d ',')
column=${workspace:0:1}
row=${workspace:1}
new=$((row + 1)); [ $new -gt 99 ] && new=99
new_name=$column$new_row
swaymsg move container to workspace $new_name
