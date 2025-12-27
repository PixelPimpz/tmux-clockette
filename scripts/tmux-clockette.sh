#!/usr/bin/env bash
DEBUG=1
((DEBUG == 1)) && tmux display -p "tmux-clockette.sh running..."
alias getIcon="$(tmux display -p "#{@GET_ICON}")"
getIcon alert
