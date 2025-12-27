#!/usr/bin/env bash
DEBUG=1
getIcon() {
  eval $(tmux display -p "#{@GET_ICON}") $1
}
((DEBUG == 1)) && tmux display -p "tmux-clockette.sh running..."
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")
nowh=(( $(time +%H)%12 ))
nowH=$hours[$now-h]
tmux display -p $nowH
