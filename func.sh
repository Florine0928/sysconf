#!/bin/bash

################################################
# Source Variables                             #
################################################

source $HOME/sysconf/var.sh

################################################
# Populate Persist                             #
################################################

populate() {
    if [ ! -d "$persist" ]; then
        echo "Persist directory is missing, we will create it"
        mkdir -p "$persist"

        touch "$persist/wallpaper"
        touch "$persist/scheme"
        touch "$persist/backend"
        touch "$persist/wall_util"
        touch "$persist/bar"
        touch "$persist/wbackend"
        
        # defaults
        echo "dark" > "$persist/scheme"
        echo "matugen" > "$persist/backend"
        echo "swaybg" > "$persist/wall_util"
        echo "waybar" > "$persist/bar"
        echo "wayland" > "$persist/wbackend"
    fi
}

################################################
# Fetch Colors via backend                     #
################################################

pywal-util() {
    if [[ $scheme == "dark" ]]; then
        wal -i $wall 
    else
        wal -l -i $wall # Light Mode
    fi 
} # check pywal docs to understand these arguments.

fetch() {
    if [[ $backend == "pywal" ]]; then
        pywal-util
    elif [[ $backend == "matugen" ]]; then
        matugen-util # can be found in fucking var.sh file because uhhhhh blame richard stallman because I couldn't import SINGULAR functions from here into other files without importing the whole fucking script.
    fi
} 

################################################
# Wallpaper Function                           #
################################################

wallutil() {
if [[ $wall_util != "no" ]]; then
# Check if wallpaper utility is running
if pgrep -x "$wall_util" > /dev/null
then
    pkill -x "$wall_util"
fi # ref line 49
fi # ref line 47

# sudo mka bacon
if [[ $wall_util == "swaybg" ]]; then
    nohup swaybg -i $wall > /dev/null 2>&1 &
elif [[ $wall_util == "feh" ]]; then
    nohup feh --bg-scale $wall > /dev/null 2>&1 &
fi
}

################################################
# Waybar Function                              #
################################################

bar_init() {
if [[ $bar != "no" ]]; then
# Check if bar is running
if pgrep -x "$bar" > /dev/null
then
    pkill -x "$bar"

fi # ref line 70
fi # ref line 68

if [[ $bar == "waybar" ]]; then 
    nohup $bar > /dev/null 2>&1 &
elif [[ $bar == "polybar" ]]; then
    nohup $bar mybar > /dev/null 2>&1 &
elif [[ $bar == "eww" ]]; then
    nohup eww open mybar > /dev/null 2>&1 &
elif [[ $bar == "ags" ]]; then
    nohup ags > /dev/null 2>&1 &
fi
}