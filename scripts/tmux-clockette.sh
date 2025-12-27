#!/usr/bin/env bash
DEBUG=1
getIcon() {
  eval $(tmux display -p "#{@GET_ICON}") $1
}
((DEBUG == 1)) && tmux display -p "tmux-clockette.sh running..."
getIcon "alert"
