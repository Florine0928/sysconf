#!/bin/bash

########### Precompiled Colorscheme - HEX ###########

if [[ $scheme == "light" ]]; then
# Light Precompiled Colorscheme
export sys_bg=""
export sys_fg=""
export sys_principal="" # either a custom hex color or a already existing variable such as $sys_red or $sys_green
export sys_second="" # same instructions as line: 9

export sys_red=""
export sys_green=""
export sys_blue=""
export sys_yellow=""
export sys_cyan=""
export sys_magenta=""
export sys_black=""
export sys_white=""
export sys_gray=""
export sys_lightgray=""
export sys_darkgray=""
export sys_orange=""
export sys_purple=""
export sys_brown=""
export sys_pink=""
else
# Dark Precompiled Colorscheme
export sys_bg=""
export sys_fg=""
export sys_principal="" # same instructions as line: 9
export sys_second="" # same instructions as line: 9

export sys_red=""
export sys_green=""
export sys_blue=""
export sys_yellow=""
export sys_cyan=""
export sys_magenta=""
export sys_black=""
export sys_white=""
export sys_gray=""
export sys_lightgray=""
export sys_darkgray=""
export sys_orange=""
export sys_purple=""
export sys_brown=""
export sys_pink=""
fi

