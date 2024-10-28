
# Sysconf 
## Simple Rice Management utility for Linux
## Features

- Frontend to Swaybg, Feh and Pywal.
- Supports X.org and Wayland
- Multiple bars supported such as Eww, AGS, Waybar and Polybar
- Dynamic Switching between Dark and Light mode
- Everything done in terminal
- Written in bash at 3AM

## Why

I made to make my life easier.

## Dependencies
```bash
  - Wayland 
  swaybg pywal - waybar or eww or ags

  - X.org
  feh pywal - polybar or eww
```
## Installation


```bash
  cd ~
  git clone https://github.com/Florine0928/sysconf.git
  sudo ln -s sysconf/sysconf.sh /bin/sysconf
```
    
## Usage/Examples

```sh
  sysconf --wallpaper ~/Download/wallpaper.png
  sysconf --backend pywal
  sysconf --bar waybar
```
And WM users can also integrate the startup script in their config file.
```conf
  Example for Hyprland:
  exec = sysconf --reload all
```
## Feedback

If you decided to look at my code and realized its garbage please let me know so I can correct. Also if it doesn't work you can tweak the script 👍
