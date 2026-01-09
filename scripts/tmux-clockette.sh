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

    local H=$(awk -F: '{print $1}' <<< "$localtime")
    local M=$(awk -F: '{print $2}' <<< "$localtime")
    local S=$(awk -F: '{print $3}' <<< "$localtime")
    local interval=$(( 3600 - (M * 60) - S ))

    debug ">> clockette: sleeping for $interval seconds until $(( H + 1 )):00"
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
  local localtime=$1
  debug ">> localtime: $localtime"
  local hex_first="0xF144B"
  debug ">> hex_first: $hex_first"
  local h="$(awk -F: '{print $1}' <<< $localtime )"
  debug ">> hour:$h"
  local hex_cur_h="$(( hex_first + h - 1 ))"
  debug ">> hex_cur_h: $hex_cur_h"
}

main  
