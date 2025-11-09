#!/usr/bin/env bash
ws=$(swaymsg -t get_workspaces | grep -B3 '"focused": true,' | head -n1 | awk '{print $2}' | tr -d ',')
col=${ws:0:1}; row=${ws:1}
new=$((row + 1)); [ $new -gt 99 ] && new=99
swaymsg workspace $col$new
