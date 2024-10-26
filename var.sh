#!/bin/bash
export persist="$HOME/sysconf/persist"
export wall=$(cat $persist/wallpaper) # sudo make bacon
export wall_util=$(cat $persist/wall_util) # feh for X.org / swaybg for Wayland | overwrite with "no" to disable.
export scheme=$(cat $persist/scheme) # dark/light
export backend=$(cat $persist/backend) # colorscheme backend | manual/pywal/matugen
export wbackend=$(cat $persist/wbackend) # x/wayland
export bar=$(cat $persist/bar) # polybar and eww for X.org / waybar, eww and ags for Wayland | overwrite with "no" to disable.

if [[ $backend == "manual" ]]; then 
# Custom Colorscheme
source $HOME/sysconf/custom.sh
fi

###################################################################################################################################################################################################
# this is here because I can't import functions from other scripts or something blame richard stallman!!!!!!!!!!!!!
matugen-util() {
        $HOME/.cargo/bin/matugen image $wall -j hex > $persist/matugen.json # generates a json with both dark and light colors, so we can parse from same file I guess.
        jq -r '.colors.dark | to_entries[] | "export " + .key + "=\"" + .value + "\"" ' $persist/matugen.json > $persist/matugen-dark.sh
        jq -r '.colors.light | to_entries[] | "export " + .key + "=\"" + .value + "\"" ' $persist/matugen.json > $persist/matugen-light.sh
} # Material You 

pywal-util() {
    if [[ $scheme == "dark" ]]; then
        wal -i $wall -n -q -s -R
    else
        wal -i $wall -n -q -s -l -R # Light Mode
    fi 
} # check pywal docs to understand these arguments.
###################################################################################################################################################################################################

########### Pywal Colorscheme ###########

if [[ $backend == "pywal" ]]; then 
pywal-util # Refresh Pywal cache
source $HOME/.cache/wal/colors.sh
if [[ $scheme == "light" ]]; then
# Light Pywal Colorscheme
export sys_bg="$background"
export sys_fg="$foreground"
export sys_principal="$color10"
export sys_second="$color15"
else
# Dark Pywal Colorscheme 
export sys_bg="$background"
export sys_fg="$foreground"
export sys_principal="$color1"
export sys_second="$color8"
fi
fi
########### Matugen Colorscheme ###########

if [[ $backend == "matugen" ]]; then 
matugen-util # Refresh Matugen cache
if [[ $scheme == "light" ]]; then
# Light Matugen Colorscheme
source $persist/matugen-light.sh
export sys_bg="$on_background"
export sys_fg="$on_background"
export sys_principal="$primary"
export sys_second="$on_primary"
else
# Dark Matugen Colorscheme
source $persist/matugen-dark.sh
export sys_bg="$on_background"
export sys_fg="$on_background"
export sys_principal="$primary"
export sys_second="$on_primary"
fi
fi
