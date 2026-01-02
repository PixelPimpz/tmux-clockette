#!/usr/bin/env bash
DEBUG=$( tmux display -p "#{@DEBUG}" )
CLOCKETTE_PID="/tmp/tmux-clockette.pid"

cleanup() {
  debug ">> Stopping tmux-clockette"
  rm -f "/tmp/tmux-clockette.pid"
  set -g '@clock' ''
}

trap cleanup EXIT 

main() {
  echo $$ > "$CLOCKETTE_PID"
  tmux bind -r C-X debug "Stopping tmux-clockette." \; run-shell "kill $(cat $CLOCKETTE_PID )"
  debug ">> clockette START. [CTRL-X] to stop"

  while true; do 
    local localtime=$(date +%-I:%M:%S)
    setClock "$localtime"

    local M=$(awk -F: '{print $2}' <<< "$localtime")
    local S=$(awk -F: '{print $3}' <<< "$localtime")
    local interval=$(( 3600 - (M * 60) - S ))

    debug ">> clockette: sleeping for $interval seconds until $(( M + 1 )):00"
    sleep "$interval"
  done 
}

debug() {
  local message="$1"
  if (( DEBUG == 1 )); then
    tmux display -p "$message"
  fi
}
 
setClock() {
  local localtime="$1"
  local clock_start=0xF144B
  local hour="$(awk -F: '{printf "%d\n", $1}' <<< $localtime)"
  local clock_now=$(( clock_start + hour - 1 ))
  local clock=$( printf "\U%x" "$clock_now" )
  tmux set -g '@clock' "$clock"
}

main 
