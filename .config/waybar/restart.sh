#! /usr/bin/env bash

pid=$(ps aux | grep -m 1 waybar | awk '{ print $2 }')

# TOdo: confirmar o pid com nome antes

kill -9 "$pid"

waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css >/dev/null 2> mango_start_err.log &

