#!/bin/bash

############################################### Configurator Script!!!!!!!!!!!!!!!!!!!!!!!! ###############################################

# Import variables and functions
source $HOME/sysconf/backend.sh

populate # persist

help_array=() # Contains reloadable things such as bar IF they are not disabled

# Check each variable and add it to the array if it meets the condition
for var in "$wall_util" "$bar"; do
    if [[ "$var" != "no" ]]; then
        help_array+=("$var")
    fi
done

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  --help, -h                    Shows this help message"
    echo "  --wallpaper <path to file>    Set wallpaper target"
    echo "  --util <swaybg/feh|auto>      Specify the wallpaper utility (swaybg, feh or auto. "no" to disable)"
    echo "  --bar <option>                Set the bar to execute at start (waybar, polybar, ags, eww. "no" to disable)"
    echo "  --scheme <type>               Set the color scheme (light or dark)"
    echo "  --backend <type>              Choose backend (pywal, manual)"
    echo "  --reload <option>             Reload Rice (Options: all $backend ${help_array[@]})"
    echo
    echo "Example:"
    echo "  $0 --wallpaper my_wallpaper.jpg --scheme dark"
    echo "  $0 --reload all"
    exit 1
}


while [[ $# -gt 0 ]]; do
    case "$1" in
        --wallpaper)
            echo "$2" > "$persist/wallpaper"
            unset wall
            wall="$2"
            reload_all
            shift 2
            ;;
        --util)
            if [[ "$2" == "feh" ]] && [[ "$XDG_SESSION_TYPE" != "wayland" ]]; then
                echo "$2" > "$persist/wall_util"
                unset wall_util
                wall_util="$2"
                wallutil
            elif [[ "$2" == "feh" ]] && [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
                echo "$1: cannot use $2 as wallpaper setter on $XDG_SESSION_TYPE."
            elif [[ "$2" == "swaybg" ]] && [[ "$XDG_SESSION_TYPE" != "x11" ]]; then
                echo "$2" > "$persist/wall_util"
                unset wall_util
                wall_util="$2"
                wallutil
            elif [[ "$2" == "swaybg" ]] && [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
                echo "$1: cannot use $2 as wallpaper setter on $XDG_SESSION_TYPE."
            elif [[ "$2" == "auto" ]]; then
                if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
                    echo "swaybg" > "$persist/wall_util"
                    unset wall_util
                    wall_util="swaybg"
                    wallutil
                elif [[ $XDG_SESSION_TYPE == "x11" ]]; then
                    echo "feh" > "$persist/wall_util"
                    unset wall_util
                    wall_util="feh"
                    wallutil
                fi
            elif [[ "$2" == "no" ]]; then
                pkill $wall_util
                echo "$2" > "$persist/wall_util"
            else
                echo "$1 Illegal Operation"
            fi
            shift 2
            ;;
        --scheme)
            if [[ "$2" == "dark" ]]; then
                echo "$2" > "$persist/scheme"
                unset scheme
                scheme="$2"
                reload_all
            elif [[ "$2" == "light" ]]; then
                echo "$2" > "$persist/scheme"
                unset scheme
                scheme="$2"
                reload_all
            else
                echo "$1: Illegal Operation"
            fi
            shift 2
            ;;
        --backend)
            if [[ "$2" == "pywal" ]]; then
                echo "$2" > "$persist/backend"
                unset backend
                backend="$2"
                bar_symlink
                reload_all
            elif [[ "$2" == "manual" ]]; then
                echo "$2" > "$persist/backend"
                unset backend
                backend="$2"
                bar_symlink
                reload_all
            else
                echo "$1: Illegal Operation"
            fi
            shift 2
            ;;
        --bar)
            if [[ "$2" == "eww" ]]; then
                echo "$2" > "$persist/bar"
                unset bar
                bar="$2"
                bar_init
            elif [[ "$2" == "polybar" ]] && [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
                echo "$2" > "$persist/bar"
                unset bar
                bar="$2"
                bar_init
            elif [[ "$2" == "ags" ]] && [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
                echo "$2" > "$persist/bar"
                unset bar
                bar="$2"
                bar_init
            elif [[ "$2" == "waybar" ]] && [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
                echo "$2" > "$persist/bar"
                unset bar
                bar="$2"
                bar_init
            elif [[ "$2" == "no" ]]; then
                pgrep -x "$bar" > /dev/null && pkill -x "$bar"
                echo "$2" > "$persist/bar"
            else
                echo "$1: Illegal Operation"
            fi
            shift 2
            ;;
        --reload)
            case "$2" in
                "$backend")
                if [[ $backend != "manual" ]]; then
                    fetch
                elif [[ "$backend" == "manual" ]]; then
                    source $HOME/sysconf/custom.sh
                fi  
                    ;;
                "$wall_util")
                if [[ "$wall_util" != "no" ]]; then
                    wallutil
                else
                    echo "ERROR: Cannot reload disabled component"
                fi
                    ;;
                "$bar")
                if [[ $bar != "no" ]]; then
                    bar_init
                else 
                    echo "ERROR: Cannot reload disabled component"
                fi
                    ;;
                "all")
                    reload_all
                    ;;
                *)
                    echo "$1: Illegal Operation"
                    ;;
    esac
    shift 2  # Shift twice to skip the option and its argument
    ;;
        -h)
            usage
            ;;
        --help)
            usage
            ;;
        *)
            echo "Invalid option: $1"
            usage
            ;;
    esac
done
