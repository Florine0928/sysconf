#!/bin/bash

############################################### Configurator Script!!!!!!!!!!!!!!!!!!!!!!!! ###############################################

# Import variables and functions
source $HOME/sysconf/var.sh
source $HOME/sysconf/func.sh

populate

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help                    Shows this help message"
    echo "  --wallpaper <path to file>    Set wallpaper target"
    echo "  --wall-util <swaybg/feh>      Specify the wallpaper utility (wayland - swaybg / feh - x.org)"
    echo "  --bar <option>                Set the bar to execute at start (wayland - eww, ags, waybar / eww, polybar - x.org)"
    echo "  --scheme <type>               Set the color scheme (light or dark)"
    echo "  --backend <type>              Choose backend (pywal, matugen (very uncomplete), manual)"
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
            shift 2
            ;;
        --wall-util)
            if [[ "$2" == "feh" ]] && [[ "$wbackend" == "xorg" ]]; then
                echo "feh" > "$persist/wall_util"
            elif [[ "$2" == "swaybg" ]] && [[ "$wbackend" == "wayland" ]]; then
                echo "swaybg" > "$persist/wall_util"
            else
                echo "--wall-util: Illegal Operation, did you set backend? --sb <wayland/xorg>"
            fi
            shift 2
            ;;
        --scheme)
            if [[ "$2" == "dark" ]]; then
                echo "dark" > "$persist/scheme"
            elif [[ "$2" == "light" ]]; then
                echo "light" > "$persist/scheme"
            else
                echo "--scheme: Illegal Operation"
            fi
            shift 2
            ;;
        --backend)
            if [[ "$2" == "pywal" ]]; then
                echo "pywal" > "$persist/backend"
            elif [[ "$2" == "matugen" ]]; then
                echo "matugen" > "$persist/backend"
            elif [[ "$2" == "manual" ]]; then
                echo "manual" > "$persist/backend"
            else 
                echo "--backend: Illegal Operation"
            fi
            shift 2
            ;;
        --sb)
            if [[ "$2" == "wayland" ]]; then
                  echo "wayland" > "$persist/wbackend"
            elif [[ "$2" == "xorg" ]]; then
                echo "xorg" > "$persist/wbackend"
            else 
                echo "--sb: Illegal Operation"
            fi
            shift 2
            ;;
        --bar)
            if [[ "$2" == "eww" ]]; then
                echo "eww" > "$persist/bar"
            elif [[ "$2" == "polybar" ]] && [[ "$wbackend" == "xorg" ]]; then
                echo "polybar" > "$persist/bar"
            elif [[ "$2" == "ags" ]] && [[ "$wbackend" == "wayland" ]]; then
                echo "ags" > "$persist/bar"
            elif [[ "$2" == "waybar" ]] && [[ "$wbackend" == "wayland" ]]; then
                echo "waybar" > "$persist/bar"
            else
                echo "--bar: Illegal Operation, did you set backend correctly? --sb <wayland/xorg>"
            fi
            shift 2
            ;;
        --reload)
            case "$2" in
                "$backend")
                    fetch
                    ;;
                "$wall_util")
                    wallutil
                    ;;
                "$bar")
                    bar_init
                    ;;
                "all")
                    fetch
                    wallutil
                    bar_init
                    ;;
        *)
            echo "--reload: Illegal Option"
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