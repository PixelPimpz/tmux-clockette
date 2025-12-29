#!/usr/bin/env bash
DEBUG=1
TIMER_PID=
## get clock icons from nerdfonts
main() {
  LOCALTIME="$(date +%-I:%M:%S)"
  ## load clock nerdfont clock glyphs 
  # start with the 1o'clock and add 11
  # outline variant: 0xF144B
  # solid variant:   0xF143F
  CLOCK=$( echo -e "\\U$(printf '%x\n' $((0xF144B + $(date +%I) - 1 )))")
  INTERVAL=$(getInterval "$LOCALTIME")
  
  # report VARS and VALS to stdout
  debug "scripts/tmux-clockette.sh is running..."
  debug ">> CLOCK: ${CLOCK}"
  debug ">> LOCALTIME: ${LOCALTIME}"
  debug ">> INTERVAL: ${INTERVAL}"
  
  # set clock
  setClock "${CLOC}"
  startTimer "$INTERVAL" "cleanup" & TIMER_PID=$!
  debug ">> TIMER_PID: $TIMER_PID"
}

startTimer() {
  local SEC="$1"
  local ACTION="$2"
  (
    sleep 15
    debug ">> setting clock at $(date +%T)"
    "$ACTION"
  ) &
  #map a key to stop the timer
  tmux bind -r C-X display -p ">> Stopping clockette timer." \; run-shell "kill ${TIMER_PID}"
  debug ">> TIMER for $ACTION started for $SEC seconds"
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
  local clock="$1"
  tmux set -g '@clock' "$clock"
}

cleanup() {
  local TPID="$1"
  debug ">> Timer complete. Checking for zombie processes..."
  if kill -0 "$timer_pid" &> /dev/null; then
    kill "$TPID"
  fi
  main
}

main
