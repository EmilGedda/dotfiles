#! /bin/sh

export PANEL_HEIGHT=10
export PANEL_FONT="xft:Consolas:size=9"
export PANEL_WM_NAME="bspwm_panel"

if xdo id -a "$PANEL_WM_NAME" > /dev/null ; then
	printf "%s\n" "The panel is already running." >&2
	exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"
[ -e "$PANEL_FIFO1" ] && rm "$PANEL_FIFO1"
mkfifo "$PANEL_FIFO1"
[ -e "$PANEL_FIFO2" ] && rm "$PANEL_FIFO2"
mkfifo "$PANEL_FIFO2"

bspc config top_padding $PANEL_HEIGHT
bspc subscribe report > "$PANEL_FIFO" &
xtitle -sf 'T%s' > "$PANEL_FIFO" &

function clock(){ 
    while true; do
	date +'S%H:%M' > "$PANEL_FIFO" 
	sleep 5
    done
} 

clock &

. panel_colors

tee -a $PANEL_FIFO1 $<$PANEL_FIFO >$PANEL_FIFO2 &

panel_bar < "$PANEL_FIFO1" | lemonbar -a 32 -n "$PANEL_WM_NAME" -g 1920x$PANEL_HEIGHT -f "$PANEL_FONT" -F "$COLOR_DEFAULT_FG" -B "$COLOR_DEFAULT_BG" & 

panel_bar < "$PANEL_FIFO2" | lemonbar -a 32 -n "$PANEL_WM_NAME" -g 1680x$PANEL_HEIGHT+1920+0 -f "$PANEL_FONT" -F "$COLOR_DEFAULT_FG" -B "$COLOR_DEFAULT_BG" &

wid=$(xdo id -a "$PANEL_WM_NAME")
tries_left=20
while [ -z "$wid" -a "$tries_left" -gt 0 ] ; do
	sleep 0.05
	wid=$(xdo id -a "$PANEL_WM_NAME")
	tries_left=$((tries_left - 1))
done

for w in $wid; do
    xdo id -N Bspwm -n root | xargs -I% xdo above -t "%" "$w"
done

wait
