#!/bin/bash
if [ "$1" == "set" ]; then
    FONT=$(xrdb -query -all \
        | grep URxvt.font | cut -d: -f2- \
        | xargs | sed "s;pixelsize=[^:]*;pixelsize=$2;")

    printf '\33]50;%s%d\007' "$FONT"
    echo "URxvt.font:   $FONT" | xrdb -merge
elif [ "$1" == "get" ]; then
    xrdb -query -all | grep URxvt.font | cut -d: -f4 | cut -d= -f2
fi
