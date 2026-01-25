#!/usr/bin/env bash
PID_FILE="/tmp/tmux-clockette.pid"
SHARE="$(tmux show -gqv @CHER)"
source "$SHARE/dump.fun"
LOCAL_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ ! -f $PID_FILE || ! ps -p "$(cat $PID_FILE )" >/dev/null ]; then
    tmux run-shell -b "$LOCAL_ROOT/scripts/tmux-clockette.sh"
  else
    tmux display -p "clockette is running@ \"Let it be.\" --The Beatles"
    exit 0
fi
