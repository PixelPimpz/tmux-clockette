#!/usr/bin/env bash
DEBUG=1
((DEBUG == 1)) && tmux display -p "tmux-clockette.sh running..."

getIcon() {
  eval $(tmux display -p "#{@GET_ICON}") $1
}
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")
time_h=$(( 1+$( date +%-H )%12 ))
hour="${hours[$time_h]}"
tmux display -p "time: $hour"
