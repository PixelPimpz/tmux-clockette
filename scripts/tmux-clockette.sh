#!/usr/bin/env bash
DEBUG=1
((DEBUG == 1)) && tmux display -p "tmux-clockette.sh running..."
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")

getIcon() {
  eval $(tmux display -p "#{@GET_ICON}") $1
}
h=$( date +%l )
hour="${hours[((h-1))]}"
tmux set -g '@clock' "$(getIcon $hour)"
if (( DEBUG == 1 )); then
  tmux display -p "time: $hour $(getIcon $hour)"
  tmux display -p "$(printf 'next check in %d seconds.\n' $next)"
  tmux display -p ">> $(date +%s)" 
fi
