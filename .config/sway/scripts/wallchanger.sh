#!/bin/bash

while true; do 
    WALLPAPER_DIR="$HOME/wallpapers"
    RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
    pkill swaybg
    swaybg -i "$RANDOM_WALLPAPER" -m fill &
    sleep 600; 
done
