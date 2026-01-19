#!/usr/bin/env bash
DEBUG=$( tmux display -p "#{@DEBUG}" )
CLOCKETTE_PID="/tmp/tmux-clockette.pid"

debug() {
  local message="$1"
  if (( DEBUG == 1 )); then
    tmux display -p "$message"
  fi
}

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
    local localtime=$(date +%-I:%M:%S:%p)
    local H=$(awk -F: '{print $1}' <<< "$localtime")
    local M=$(awk -F: '{print $2}' <<< "$localtime")
    local S=$(awk -F: '{print $3}' <<< "$localtime")
    local P=$(awk -F: '{print $4}' <<< "$localtime")
    local interval=$(( 3600 - (M * 60) - S ))
    setClock "$H"

    debug ">> clockette: sleeping for $interval seconds until $(( H + 1 )):00$P"
    sleep "$interval"
  done 
}

 
setClock() 
{
  local hour=$1
  local hex_base="0xF144B"
  local hex_now="$( printf '%X\n' "$(( hex_base + hour - 1 ))")"
  local icon="$( echo -e "\U$hex_now")"
  debug ">> icon: $icon"
  tmux set -g @clock "$icon"
  tmux set -g @clockette "#[fg=#{@DarkOrange}]#{@TriangleL}#[reverse]#{clock} %I:%m%s #[bg=default]#[noreverse]#{@TriangleRInverse}"
}

main  
