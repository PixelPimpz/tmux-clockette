#!/usr/bin/env bash
DEBUG=1
((DEBUG == 1)) && tmux display -p "tmux-clockette.sh running..."
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")

main() {
  h=$( date +%l )
  hour="${hours[((h-1))]}"
  tmux set -g '@clock' "$(getIcon $hour)"
  (( DEBUG == 1 )) && interval; debug
}

interval() {
  local now="$(date +%l:%M:%S)"
  local delta_s=$((60 - $(awk -F: '{print $3}' <<< $now) )) 
  local delta_m=$((60 - $(awk -F: '{print $2}' <<< $now) )) 

}

getIcon() {
  eval $(tmux display -p "#{@GET_ICON}") $1
}

debug() {
  tmux display -p "time: $hour $(getIcon $hour)"
  local next="$(( $(date -d 'next hour' +%s)-$(date +%s)-$(date +%S) ))" 
  tmux display -p "$(printf 'next check in %d seconds.\n' $next)"
}
main
