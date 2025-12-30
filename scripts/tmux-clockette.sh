#!/usr/bin/env bash
DEBUG=0
TIMER_PID=

## get clock icons from nerdfonts
main() {
  debug "scripts/tmux-clockette.sh is running..."
  timer 
}

timer() {
  local pid=$!
  local firstrun=
  local localtime="$(date +%-I:%M:%S)"
  local interval=$(getInterval "$localtime")
  [[ -z $firstrun ]] && setClock "$localtime" && firstrun="false"
  debug ">> sleeping for $interval until $(awk -F: -v OS='1' '{printf "%d:00", OS + $1 }')"
  (
    sleep $interval

    debug ">> setting clock at $localtime"
    setClock "$localtime"
    timeManager 
  ) &
  
  debug ">> TIMER for $ACTION started for $SEC seconds"
  #map a key to stop the timer
  tmux bind -r C-X display -p ">> Stopping clockette timer." \; run-shell "kill ${TIMER_PID}"
  debug ">> [CTRL]+X to abort timer"
}

getInterval() {
  local T="$1"
  local s_to_next_m="$(( 60 - $(awk -F: '{printf "%d\n", $3}' <<< $T)))"
  local m_to_next_h="$(( 60 - $(awk -F: '{printf "%d\n", $2}' <<< $T)))"
  tmux display -p "$(( (m_to_next_h * 60) + s_to_next_m ))"
}

debug() {
  local M="$1"
  if (( DEBUG == 1 )); then
    tmux display -p "$M"
  fi
}
 
setClock() {
  local localtime="$1"
  ## load clock nerdfont clock glyphs 
  # start with the 1o'clock and add 11
  # outline variant: 0xF144B
  # solid variant:   0xF143F
  local H="$(awk -F: '{printf "%d\n", $1}' <<< $localtime)"
  local CLOCK=$( echo -e "\\U$(printf '%x\n' $((0xF144B + ($H - 1) )))")
  tmux set -g '@clock' "${CLOCK}"
}

timeManager() {
  local TPID=$1
  debug ">> Timer complete. Checking for zombie processes..."
  if kill -0 "$timer_pid" &> /dev/null; then
    kill "$TPID"
  fi
  timer 
}

main
