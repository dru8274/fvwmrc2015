#!/bin/bash

# select-pane -U -t tmux1:1        # Select upper pane in window 1 of session tmux1

start_tmux_1()    {

    (( $# != 1 )) && { echo " * Exiting. Tmux session name undefined." ; return 1 ; }

    sesx="$1"

    # if the session is already exists, then return. Nothing to be done here.

    tmux has-session -t $sesx 2>/dev/null && return 0

    # elsewise, session $sesx will be created from scratch.

    tmux new-session -d -s $sesx

    winx=1
    tmux new-window -t $sesx:$winx -k -n root    # ' su - '
#    tmux split-window -h -l 18 -t $sesx:$winx
    #tmux split-window -v -t $sesx:$winx
    #tmux select-layout  -t $sesx:$winx main-horizontal
#    tmux select-pane -L -t $sesx:$winx

    tmux new-window -t $sesx:2 -n alpha

    tmux new-window -t $sesx:3 -n bravo

    tmux new-window -t $sesx:4 -n charlie

    tmux new-window -t $sesx:5 -n delta

    winx=6
    tmux new-window -t $sesx:$winx -n epsilon
    tmux split-window -v -p 50 -t $sesx:$winx
#    tmux select-pane -U -t $sesx:$winx
#    tmux split-window -v -p 50 -t $sesx:$winx
    #tmux select-layout -t $sesx:$winx main-horizontal
    tmux select-pane -U -t $sesx:$winx

    tmux select-window -t $sesx:1
}

start_tmux_1 $1


