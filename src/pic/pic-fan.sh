#!/bin/bash

SIZE=50
CENTER=$((SIZE / 2))
NUM_FRAMES=12
COLOR="black"
BG="white"

BLADE_LENGTH=12   # длина от центра
BLADE_WIDTH=6     # общая ширина лопасти

OUTDIR="./fan_frames"
mkdir -p "$OUTDIR"

for ((i = 0; i < NUM_FRAMES; i++)); do
    ANGLE=$((i * 30))

    convert -size ${SIZE}x${SIZE} canvas:$BG \
        -fill "$COLOR" -stroke none \
        -draw "push graphic-context
                 translate $CENTER,$CENTER
                 rotate $ANGLE

                 path 'M0,0 
                       L$BLADE_LENGTH,-$((BLADE_WIDTH/2)) 
                       L$BLADE_LENGTH,$((BLADE_WIDTH/2)) 
                       Z'

                 rotate 120
                 path 'M0,0 
                       L$BLADE_LENGTH,-$((BLADE_WIDTH/2)) 
                       L$BLADE_LENGTH,$((BLADE_WIDTH/2)) 
                       Z'

                 rotate 120
                 path 'M0,0 
                       L$BLADE_LENGTH,-$((BLADE_WIDTH/2)) 
                       L$BLADE_LENGTH,$((BLADE_WIDTH/2)) 
                       Z'
               pop graphic-context" \
        "$OUTDIR/frame_$(printf %02d "$i").png"
done

