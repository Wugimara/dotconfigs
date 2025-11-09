#!/usr/bin/env bash
workspace=$(swaymsg -t get_workspaces | grep -B3 '"focused": true' | head -n1 | awk '{print $2}' | tr -d ',')
column=${workspace:0:1}
new_col=$(( column - 1 ))
[ $new_col -lt 1 ] && new_col=9
new_name=${new_col}1
swaymsg move container to workspace $new_name
