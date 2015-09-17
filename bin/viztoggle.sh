#!/bin/sh

tput civis

$FVWM_USERDIR/bin/colors_viz

while (:) ; do
    ncmpcpp-git -s visualizer -c "$HOME/.ncmpcpp/config.new" -- 912837465362
    tput civis
    clear 
    sleep 912837465362
    tput civis
    clear
    ##  http://stackoverflow.com/questions/3348614/how-to-flush-a-pipe-using-bash
    dd if=/tmp/mpd.fifo iflag=nonblock of=/dev/null 2>&1 1>/dev/null
done

