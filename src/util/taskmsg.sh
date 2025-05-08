#!/bin/sh

MY_TTY=$(tty)

echo "taskmsg + $MY_TTY" > "$MY_TTY"
