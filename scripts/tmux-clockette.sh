#!/usr/bin/env bash
DEBUG=1
GET_ICON=$(tmux display -p "#{@GET_ICON}") 
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")

main() {
  local now="$(date +%l:%M:%S)"
  local now_hd="$(awk -F: '{print $1}' <<< $now)"
  local now_ht="${hours[$((now_hd-1))]}"
  local interval="$(getInterval $now)" 
  tmux set -g '@clock' "$(getIcon ${now_ht})"
  if (( DEBUG != 0 ));then
    tmux display -p "tmux-clockette.sh is running..."
    tmux display -p ">> GET_ICON: $GET_ICON"
    tmux display -p ">> Current hour: ${now_ht}"
    tmux display -p ">> ${interval} seconds to $(( now_hd + 1 )):00"
  fi
}

getInterval() {
  local now="$1"
  local s_to_minute=$((60 - $(awk -F: '{print $3}' <<< $now) )) 
  local m_to_hour=$((60 - $(awk -F: '{print $2}' <<< $now) )) 
  local s_to_hour=$(( ( m_to_hour * 60 ) + s_to_minute ))
  echo "${s_to_hour}"
}

getIcon() {
  local hour="$1"
  local H="$("$GET_ICON" "$hour")"
  echo "$H"
}

debug() {
  local D="$1"
  tmux display -p "$D"
}
main
