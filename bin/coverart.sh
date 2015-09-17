#!/bin/bash

##  Coverart script. Extracts cover art imahes from an mp3 using eyeD3.
##  Converts it to the right size with imagemagick.
##  Sends an fvwm command that updates the current image.

if mkdir /tmp/eyeD3 2>&1 1>/dev/null ; then

    cd /tmp/eyeD3
    rm *png *jpg *jpeg 2>&1 1>/dev/null

    #GEOM='150x150!'
    GEOM='198x198!'
    COVERART="$FVWM_USERDIR/images/coverart.png"
    DEFAULT="$HOME/Pictures/beachhouse.jpg"

    eyeD3 -i . "$1"  2>&1 1>/dev/null

    while IFS= read FILEX ;  do
        [[ -e "$FILEX" ]] && break
    done <<EOF
FRONT_COVER.png
FRONT_COVER.jpg
FRONT_COVER.jpeg
FRONT_COVER1.png
FRONT_COVER1.jpg
FRONT_COVER1.jpeg
OTHER.png
OTHER.jpg
OTHER.jpeg
EOF

    if [[ -e "$FILEX" ]] ; then
        convert -quality 95% "$FILEX" -adaptive-resize "$GEOM" "$COVERART"
    else
        convert -quality 95% "$DEFAULT" -adaptive-resize "$GEOM" "$COVERART"
    fi

    rm -r /tmp/eyeD3 2>&1 1>/dev/null

    FvwmCommand UpdateCoverArt 
fi





















