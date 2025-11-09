#!/usr/bin/env bash
workspace=$(swaymsg -t get_workspaces | grep -B3 '"focused": true,' | head -n1 | awk '{print $2}' | tr -d ',')
column=${workspace:0:1}
row=${workspace:1}
echo "C$column R$row"
