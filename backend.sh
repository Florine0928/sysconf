#!/bin/bash

################################################
# Variables                                    #
################################################

export persist="$HOME/sysconf/persist" # sudo dnf install koisz
export wall=$(cat $persist/wallpaper) # sudo make bacon
export wall_util=$(cat $persist/wall_util) # feh for X.org / swaybg for Wayland | overwrite with "no" to disable.
export scheme=$(cat $persist/scheme) # dark/light
export backend=$(cat $persist/backend) # colorscheme backend | manual/pywal/matugen
export bar=$(cat $persist/bar) # polybar and eww for X.org / waybar, eww and ags for Wayland | overwrite with "no" to disable.

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
        
        # defaults
        echo "dark" > "$persist/scheme"
        echo "pywal" > "$persist/backend"
        echo "$HOME/sysconf/default.png" > "$persist/wallpaper"
    if [[ $XDG_SESSION_TYPE == "wayland" ]]; then # Wayland hehe
        echo "swaybg" > "$persist/wall_util"
        echo "waybar" > "$persist/bar"
    else # X.org hehe
        echo "feh" > "$persist/wall_util"
        echo "polybar" > "$persist/bar"
    fi # line: 32
    fi # line: 19
}

################################################
# Fetch Colors via backend                     #
################################################

pywal-util() {
    if [[ "$scheme" == "dark" ]]; then
        wal -i $wall 
    else
        wal -l -i $wall # Light Mode
    fi 
} # check pywal docs to understand these arguments.

fetch() {
    if [[ $backend == "pywal" ]]; then
        pywal-util
        source $HOME/.cache/wal/colors.sh
        export sys_bg="$background"
        export sys_fg="$foreground"
        export sys_principal="$color10"
        export sys_second="$color15"
    elif [[ $backend == "manual" ]]; then
        source $HOME/sysconf/custom.sh
    fi
} 

################################################
# Wallpaper Function                           #
################################################

wallutil() {
if [[ "$wall_util" != "no" ]]; then
# Check if wallpaper utility is running
if pgrep -x "$wall_util" > /dev/null
then
    pkill -x "$wall_util"
fi 
fi 

# sudo mka bacon
if [[ "$wall_util" == "swaybg" && "$XDG_SESSION_TYPE" != "x11" ]]; then
    nohup $wall_util -i "$wall" > /dev/null 2>&1 &
elif [[ "$wall_util" == "feh" && "$XDG_SESSION_TYPE" != "wayland" ]]; then
    nohup $wall_util --bg-scale "$wall" > /dev/null 2>&1 &
else
    echo "ERROR: Cannot start $wall_util because it is incompatible with $XDG_SESSION_TYPE!"
fi
}

################################################
# Waybar Function                              #
################################################

bar_symlink() {
    if [[ $backend == "pywal" ]]; then
        if [[ $bar == "waybar" ]]; then
            if [ ! -e "$HOME/.config/waybar/colors-custom.css" ]; then
                ln -s "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/waybar/colors-custom.css"
            elif [ ! -e "$HOME/.cache/wal/colors-waybar.css" ]; then
                fetch
                ln -s "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/waybar/colors-custom.css"
            fi
        fi
    fi

    if [[ $backend == "manual" ]]; then
        if [[ $bar == "waybar" ]]; then
            if [ ! -e "$HOME/.config/waybar/colors-waybar.css" ]; then
                ln -s "$HOME/sysconf/colors-custom.css" "$HOME/.config/waybar/"
            fi
        fi
    fi
} # this links pywal's colors to waybar dir, where you can import the colors-custom.css into style.css and make use of pywal
  # you can look as a example at my dotfiles how I did that.

bar_init() {
    if [[ $bar != "no" ]]; then
        # Check if bar is running
    if pgrep -x "$bar" > /dev/null
    then
        pkill -x "$bar"

    fi 
    fi 

    if [[ $bar == "waybar" ]] && [[ $XDG_SESSION_TYPE == "wayland" ]]; then 
        bar_symlink
        nohup $bar > /dev/null 2>&1 & 
    elif [[ $bar == "polybar" ]] && [[ $XDG_SESSION_TYPE == "x11" ]]; then
        nohup $bar mybar > /dev/null 2>&1 &
    elif [[ $bar == "eww" ]]; then
        nohup $bar open mybar > /dev/null 2>&1 &
    elif [[ $bar == "ags" ]] && [[ $XDG_SESSION_TYPE == "wayland" ]]; then
        nohup $bar > /dev/null 2>&1 &
    fi
}

################################################
# Reload Function                              #
################################################

reload_all() {
    wallutil    
    fetch
    bar_init
}
