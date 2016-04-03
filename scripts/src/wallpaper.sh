#!/bin/zsh

function run_wallpaper() {
	if [[ $# -gt 1 ]]; then
		echo "run_wallpaper: Too many arguments" >&2
		return 1
	fi
	if [[ $# -lt 1 ]]; then
		echo "run_wallpaper: Too few arguments" >&2
		return 1
	fi
	xwinwrap -ov -g 1920x1080+$1+0 -- /usr/lib/xscreensaver/glslideshow -root -window-id WID -zoom 100 -duration 3600 -pan 3600 -fade 1 & 
}

function init_wallpaper() {
	run_wallpaper 0
	sleep 1800s && run_wallpaper 1920	
}

feh --randomize --no-fehbg --bg-fill ~/Images/Wallpapers/chromecast
pidfile="/tmp/wallpaper-pid"
if [[ -f "$pidfile" ]]; then
	echo "init_wallpaper: Already running" >&2
else 
	echo $$ > $pidfile
	init_wallpaper & 
fi
