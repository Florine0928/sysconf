#!/bin/bash

############################################### Configurator Script!!!!!!!!!!!!!!!!!!!!!!!! ###############################################

# Import variables and functions
source $HOME/sysconf/backend.sh

populate # persist

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help                    Shows this help message"
    echo "  --wallpaper <path to file>    Set wallpaper target"
    echo "  --wall-util <swaybg/feh>      Specify the wallpaper utility (swaybg, feh. "no" to disable)"
    echo "  --bar <option>                Set the bar to execute at start (waybar, polybar, ags, eww. "no" to disable)"
    echo "  --scheme <type>               Set the color scheme (light or dark)"
    echo "  --backend <type>              Choose backend (pywal, manual)"
    echo "  --sb <type>                   Specify the session backend (wayland or xorg)"
    echo "  --reload <option>             Reload Rice (Options: all, $backend, $wall_util, $bar)"
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
        --wall-util)
            if [[ "$2" == "feh" ]] && [[ "$wbackend" == "xorg" ]]; then
                echo "$2" > "$persist/wall_util"
                unset wall_util
                wall_util="$2"
                wallutil
            elif [[ "$2" == "feh" ]] && [[ "$wbackend" == "wayland" ]]; then
                echo "--wall-util: cannot use feh as wallpaper setter on wayland session."
            elif [[ "$2" == "swaybg" ]] && [[ "$wbackend" == "wayland" ]]; then
                echo "$2" > "$persist/wall_util"
                unset wall_util
                wall_util="$2"
                wallutil
            elif [[ "$2" == "swaybg" ]] && [[ "$wbackend" == "xorg" ]]; then
                echo "--wall-util: cannot use swaybg as wallpaper setter on xorg session."
            elif [[ "$2" == "no" ]]; then
                pkill $wall_util
                echo "$2" > "$persist/wall_util"
            else
                echo "--wall-util: Illegal Operation, did you set backend? --sb <wayland/xorg>"
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
                echo "--scheme: Illegal Operation"
            fi
            shift 2
            ;;
        --backend)
            if [[ "$2" == "pywal" ]]; then
                echo "$2" > "$persist/backend"
                unset backend
                backend="$2"
                reload_all
            elif [[ "$2" == "manual" ]]; then
                echo "$2" > "$persist/backend"
                unset backend
                backend="$2"
                reload_all
            else
                echo "--backend: Illegal Operation"
            fi
            shift 2
            ;;
        --sb)
            if [[ "$2" == "wayland" ]]; then
                echo "$2" > "$persist/wbackend"
                unset wbackend
                wbackend="$2"
            elif [[ "$2" == "xorg" ]]; then
                echo "$2" > "$persist/wbackend"
                unset wbackend
                wbackend="$2"
            else 
                echo "--sb: Illegal Operation"
            fi
            shift 2
            ;;
        --bar)
            if [[ "$2" == "eww" ]]; then
                echo "$2s" > "$persist/bar"
                unset bar
                bar="$2"
                bar_init
            elif [[ "$2" == "polybar" ]] && [[ "$wbackend" == "xorg" ]]; then
                echo "$2" > "$persist/bar"
                unset bar
                bar="$2"
                bar_init
            elif [[ "$2" == "ags" ]] && [[ "$wbackend" == "wayland" ]]; then
                echo "$2" > "$persist/bar"
                unset bar
                bar="$2"
                bar_init
            elif [[ "$2" == "waybar" ]] && [[ "$wbackend" == "wayland" ]]; then
                echo "$2" > "$persist/bar"
                unset bar
                bar="$2"
                bar_init
            elif [[ "$2" == "no" ]]; then
                pgrep -x "$bar" > /dev/null && pkill -x "$bar"
                echo "$2" > "$persist/bar"

            else
                echo "--bar: Illegal Operation, did you set backend correctly? --sb <wayland/xorg>"
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
                    wallutil
                    ;;
                "$bar")
                    bar_init
                    ;;
                "all")
                    reload_all
                    ;;
        *)
            usage
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
