#!/usr/bin/env bash
DEBUG=1
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")

main() {
  local now="$(date +%l:%M:%S)"
  local now_hd="$(awk -F: '{print $1}' <<< $now)"
  local now_ht="${hours[((now_hd-1))]}"
  tmux display -p "Current hour:${now_ht}"
  tmux set -g '@clock' "$(getIcon ${now_ht})"
  local interval=$(getInterval "$now") 
}

getInterval() {
  local now="$1"
  local s_to_minute=$((60 - $(awk -F: '{print $3}' <<< $now) )) 
  local m_to_hour=$((60 - $(awk -F: '{print $2}' <<< $now) )) 
  local s_to_hour=$(( (m_to_hour * 60)+ s_to_minute ))
  if (( DEBUG == 1 )); then
    tmux display -p "tmux-clockette.sh is running..."
    debug "$(tmux display -p "${s_to_minute} seconds to next minute")"
    debug "$(tmux display -p "${m_to_hour} minutes to next hour")"
    debug "$(tmux display -p "${s_to_hour} seconds to next hour")"
  fi
  echo "${s_to_hour}"
}

getIcon() {
  eval $(tmux display -p "#{@GET_ICON}") $1
}

debug() {
  local D="$1"
  tmux display -p "$D"
}
main
