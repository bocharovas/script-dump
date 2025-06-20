#!/bin/sh

RECT_WIDTH=26
RECT_HEIGHT=13
PADDING=50
TOTAL_WIDTH=$((RECT_WIDTH + 2 * PADDING))
TOTAL_HEIGHT=$RECT_HEIGHT
COLOR="rgb(144,238,144)"   # салатовый (lightgreen)

OUTPUT="$HOME/Pictures/green_rect_with_padding.png"

convert -size ${TOTAL_WIDTH}x${TOTAL_HEIGHT} xc:transparent \
  -fill "$COLOR" -draw "rectangle ${PADDING},0 $((PADDING + RECT_WIDTH - 1)),$((RECT_HEIGHT - 1))" \
  PNG32:"$OUTPUT"

echo "Создано изображение: $OUTPUT"

