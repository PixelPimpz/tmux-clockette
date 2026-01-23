#!/usr/bin/env bash
CLOCKETTE_PID="/tmp/tmux-clockette.pid"
SHARE="$( tmux show -gqv @CHER )"
source "$SHARE/dump.fun"
source "$SHARE/fatal.fun"

trap fatal EXIT

main() 
{
  echo $$ > "$CLOCKETTE_PID"
  tmux bind -r C-X dump "Stopping tmux-clockette." \; run-shell "kill $(cat $CLOCKETTE_PID )"
  dump ">> clockette START. [CTRL-X] to stop"

  while true; do 
    local localtime=$(date +%-I:%M:%S:%p)
    local H=$(awk -F: '{print $1}' <<< "$localtime")
    local M=$(awk -F: '{print $2}' <<< "$localtime")
    local S=$(awk -F: '{print $3}' <<< "$localtime")
    local P=$(awk -F: '{print $4}' <<< "$localtime")
    local interval=$(( 3600 - (M * 60) - S ))
    setClock "$H"

    dump ">> clockette: sleeping for $interval seconds until $(( H + 1 )):00$P"
    sleep "$interval"
  done 
}
 
setClock() 
{
  local hour=$1
  (( "$hour" >= 10 )) && local spacer=' ' || local spacer=''
  local hex_base="0xF143F"
  local hex_now="$( printf '%X\n' "$(( hex_base + hour - 1 ))")"
  local icon="$( echo -e "\U$hex_now")"
  dump ">> icon: ${icon}"
  tmux set -g @clock "$icon"
  tmux set -g @clockette "#[fg=#{@orange_b}]#{@TriangleL}#[bg=#{@bg0},bold]#[reverse]#{@clock} $hour#[blink]:#[noblink]%M%P #[bg=default]#[noreverse]#{@TriangleRInverse}"
  tmux set -g @calendar "#[fg=#{@green}]#{@TriangleL}#[bg=#{@bg0},bold]#[reverse]%a %m|%e|%Y #[bg=default]#[noreverse]#{@HemiR}"
}

main  
