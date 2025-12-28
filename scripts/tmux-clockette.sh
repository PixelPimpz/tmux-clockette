#!/usr/bin/env bash
DEBUG=1
GET_ICON=$(tmux display -p "#{@GET_ICON}") 
hours=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve")

main() {
  local now="$(date +%l:%M:%S)"
  local now_hd="$(awk -F: '{print $1}' <<< $now)"
  local now_ht="${hours[$((now_hd-1))]}"

  ## pass the date string to getInterval for parsing
  local interval="$(getInterval $now)" 
  (( "$?" != 0 )) && fatal "getInterval failed"

  ## tmux-run getIcon with the text hour
  local clock=$(tmux run "$GET_ICON $now_ht")
  if (( DEBUG != 0 ));then
    tmux display -p "tmux-clockette.sh is running..."
    tmux display -p ">> GET_ICON: $GET_ICON"
    tmux display -p ">> clock: $clock"
    tmux display -p ">> Current hour: ${now_ht}"
    tmux display -p ">> ${interval} seconds to $(( now_hd + 1 )):00"
  fi
  setClock "$clock"
}

# set a global tmux option (-g) '@clock' 
# with the newly acquired clock icon
# TODO? read the 12 icons from unicodes. 
# only the first address need be known 
# access the rest with (( 0xXXXX++ ))
setClock() {
  local clock=$1
  tmux set -g '@clock' "$clock"
  tmux source "$TMUX_ROOT/tmux.conf"
}

getInterval() {
  local now="$1"
  local s_to_minute=$((60 - $(awk -F: '{print $3}' <<< $now) )) 
  local m_to_hour=$((60 - $(awk -F: '{print $2}' <<< $now) )) 
  local s_to_hour=$(( ( m_to_hour * 60 ) + s_to_minute ))
  echo "${s_to_hour}"
}

Timer() {
  local duration="$1"

}

debug() {
  local D="$1"
  tmux display -p "$D"
}
main
