#!/bin/sh

WIDTH=174
HEIGHT=80
THICKNESS=10
OFFSET=1
COLOR="rgba(0,0,130,1)"
OUTPUT="$HOME/Pictures/spr-frame.png"

convert -size "${WIDTH}x${HEIGHT}" xc:transparent \
  -stroke "$COLOR" -strokewidth "$THICKNESS" -fill none \
  -draw "rectangle $OFFSET,$OFFSET $((WIDTH - 1 - OFFSET)),$((HEIGHT - 1 - OFFSET))" \
  miff:- | convert miff:- PNG32:"$OUTPUT"
