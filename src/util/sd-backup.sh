#!/bin/sh

path=$(lsblk -o +SERIAL | grep 20121112761000000 | head -c 3)
echo $path 
sudo dd if=~/projects/tzmoi-viewer/.tmp/rpi-`date --iso`.img of=/dev/$path status=progress
