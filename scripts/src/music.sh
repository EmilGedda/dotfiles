#! /usr/bin/env bash

# Ugly mpd hack
# mpd prev does not actually play the previous song, while repeat is on
# Instead, it replays the current one.
# This hack allows prev/next and then wraps around if it hits bottom or top
# Potential TODO: Only do this if repeat mode is on?

POS=$(mpc status -f "%position%" | head -n1)
POSINT=1
if [[ "$1" = "prev" ]]; then
    POSINT=$(($POS - 1))
else
    POSINT=$(($POS + 1))
fi
LEN=$(mpc playlist | wc -l)

if [[ "$POSINT" -gt "$LEN" ]]; then
    mpc play 1
elif [[ "$POSINT" -lt 1 ]]; then
    mpc play $LEN
else
    mpc play $POSINT
fi
