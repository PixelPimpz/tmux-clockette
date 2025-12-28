#!/usr/bin/env bash
DEBUG=1
GET_ICON=$(tmux display -p "#{@GET_ICON}") 
## @GET_ICON=/home/lucifer/.config/tmux/plugins/tmux-geticon/scripts/tmux-geticon.sh
#
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")

main() {
  local now="$(date +%-l:%M:%S)"
  local now_hd="$(awk -F: '{print $1}' <<< $now)"
  local now_ht="${hours[$((now_hd-1))]}"

  ## pass the date string to getInterval for parsing
  local interval="$(getInterval $now)" 
  (( "$?" != 0 )) && fatal "getInterval failed"

  ## tmux-run getIcon with the text hour
  local clock=$(tmux run "$GET_ICON $now_ht")
  debug "tmux-clockette.sh is running..."
  debug ">> GET_ICON: $GET_ICON"
  debug ">> clock: $clock"
  debug ">> Current hour: ${now_ht}"
  debug ">> ${interval} seconds to $(( now_hd + 1 )):00"

  setClock "$clock"
  ## check for existing TimerPID and kill the process 
  # before starting a new one then
  # start timer to run at top of next hour
  Timer "$interval" "main" & TimerPID=$!
}

# set a global tmux option (-g) '@clock' 
# with the newly acquired clock icon
setClock() {
  local clock=$1
  tmux set -g '@clock' "$clock"
}

isInt() { [[ $1 =~ ^-?[0-9]+$ ]] }
 
getInterval() {
  local now="$1"
  local s_to_minute=$((60 - $(awk -F: '{print $3}' <<< $now) )) 
  local m_to_hour=$((60 - $(awk -F: '{print $2}' <<< $now) )) 
  local s_to_hour=$(( ( m_to_hour * 60 ) + s_to_minute ))
  echo "${s_to_hour}"
}

Timer() {
  local duration="$1"
  local action="$2"
  (( $(isInt $duration) != 0 )) && fatal "duration is not an integer"
  declare -F "$action" >/dev/null || fatal "$action not declared in this script"
  (
    sleep "$duration"
    debug ">> updating the clock icon at $(date +%l:%M:%S)"
    "$action"
  ) &
  debug "timer for $duration running..."
}

debug() {
  if (( DEBUG == 1 )); then
    local D="$1"
    tmux display -p "$D"
  fi
}
main
