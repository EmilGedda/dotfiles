
[[ -f $XDG_CONFIG_HOME/X11/Xresources ]]  && xrdb -merge -I$XDG_CONFIG_HOME/X11/Xresources.d $XDG_CONFIG_HOME/X11/Xresources

rm -f /tmp/wallpaper-pid

xrandr --output DVI-I-1 --dpi 92
xset +fp /home/emil/.local/share/fonts
sxhkd &
urxvt -uc -bc &
xsetroot -cursor_name left_ptr
xscreensaver -no-splash &
exec bspwm
