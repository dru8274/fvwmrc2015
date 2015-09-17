#!/bin/bash

QUALITY=95

[[ -e /tmp/maim ]] || mkdir /tmp/maim

cnt=1 
filex="/tmp/maim/$(printf '%04d' $cnt).png"

while [[ -e $filex ]] ; do
    cnt=$((cnt+1))
    filex="/tmp/maim/$(printf '%04d' $cnt).png"
done

case "$1" in
    selection)
        maim -s -b 7 -c 0.21,0.39,0.54 "$filex" && {
            notify-send "Screenshot : $filex" 
            echo -n $filex | xsel -ib
        }
        ;;
    currentwindow)
        scrot -z -b -u -q $QUALITY "$filex" && {
            notify-send "Screenshot : $filex" 
            echo -n $filex | xsel -ib
        }
        ;;
    5seconds)
        scrot -z -q $QUALITY -d 5 "$filex" && {
            notify-send "Screenshot : $filex" 
            echo -n $filex | xsel -ib
        }
        ;;
    10seconds)
        scrot -z -q $QUALITY -d 10 "$filex" && {
            notify-send "Screenshot : $filex" 
            echo -n $filex | xsel -ib
        }
        ;;
    now)
        scrot -z -q $QUALITY "$filex" && {
            notify-send "Screenshot : $filex" 
            echo -n $filex | xsel -ib
        }
        ;;
    *)
        exit 1
        ;;
esac



























