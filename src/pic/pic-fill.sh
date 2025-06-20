#!/bin/sh

WIDTH=51
HEIGHT=29
COLOR="rgba(255,0,0,1)"
OUTPUT="$HOME/Pictures/spr-filled.png"

convert -size "${WIDTH}x${HEIGHT}" xc:transparent \
  -fill "$COLOR" \
  -draw "rectangle 0,0 $WIDTH,$HEIGHT" \
  miff:- | convert miff:- PNG32:"$OUTPUT"

