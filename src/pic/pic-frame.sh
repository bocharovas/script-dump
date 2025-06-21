#!/bin/sh

WIDTH=51
HEIGHT=29
THICKNESS=10
OFFSET=1
COLOR="rgba(255,0,0,1)"
OUTPUT="$HOME/Pictures/spr-frame.png"

convert -size "${WIDTH}x${HEIGHT}" xc:transparent \
  -stroke "$COLOR" -strokewidth "$THICKNESS" -fill none \
  -draw "rectangle $OFFSET,$OFFSET $((WIDTH - 1 - OFFSET)),$((HEIGHT - 1 - OFFSET))" \
  miff:- | convert miff:- PNG32:"$OUTPUT"

