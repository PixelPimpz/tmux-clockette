#!/usr/bin/env bash
DEBUG=1
((DEBUG == 1)) && tmux display -p "tmux-clockette.sh running..."
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")

main() {
  local now="$(date +%l:%M:%S)"
  local now_h="$(awk -F: '{print $1}' <<< $now)"
  tmux display -p 'now_h: "${now_h}"'
  tmux set -g '@clock' "$(getIcon $now_h)"
  local interval=$(getInterval "$now") 
  tmux display -p "${interval} seconds to next hour"
  (( DEBUG == 1 )) && debug "$(tmux display -p "#{@clock}")" "${interval}" "${now}"
}

getInterval() {
  local now="$1"
  local delta_s=$((60 - $(awk -F: '{print $3}' <<< $now) )) 
  local delta_m=$((60 - $(awk -F: '{print $2}' <<< $now) )) 
  local delta=$(( ( delta_m * 60 ) + delta_s ))
  tmux display -p "${delta_s} seconds to next minute"
  tmux display -p "${delta_m} minutes to next hour"
  echo "${delta}"
}

getIcon() {
  eval $(tmux display -p "#{@GET_ICON}") $1
}

debug() {
  local clock="$1"
  local interval="$2"
  local now="$3"
  tmux display -p "time: ${now} ${clock}"
  tmux display -p "$(printf 'next check in %d seconds.\n' $interval)"
}
main
