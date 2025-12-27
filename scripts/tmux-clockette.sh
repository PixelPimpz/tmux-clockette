#!/usr/bin/env ba
DEBUG=1
((DEBUG == 1)) && tmux display -p "tmux-clockette.sh running..."

getIcon() {
  eval $(tmux display -p "#{@GET_ICON}") $1
}
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")
time_h=$( date +%-I )
(( time_h == 0 )) && $time_h=12
hour="${hours[$time_h]}"
tmux display -p "time: $hour"
tmux display -p "$( getIcon "$hour" )"
