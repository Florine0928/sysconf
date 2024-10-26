#!/bin/bash

source $HOME/sysconf/var.sh
source $HOME/sysconf/func.sh
# sudo make
populate
# ref ~/sysconf/var.sh at line: 5
if [[ $backend != "manual" ]]; then 
    fetch
fi

# set wallpaper
wallutil

# star waybar
bar_init