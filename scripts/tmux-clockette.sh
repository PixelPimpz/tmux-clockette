#!/usr/bin/env bash
DEBUG=1
((DEBUG == 1)) && tmux display -p "tmux-clockette.sh running..."

getIcon() {
  eval $(tmux display -p "#{@GET_ICON}") $1
}
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")
h=$( date +%-H )
time_h=$(( (h%12)-1  ))
(( time_h == 0 )) && $time_h=12
hour="${hours[$time_h]}"
tmux display -p "time: $hour"
