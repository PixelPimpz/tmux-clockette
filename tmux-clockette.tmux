#!/usr/bin/env bash
tmux setenv '@PLUG_ROOT' "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLUG_ROOT=$( tmux display -p "#{@PLUG_ROOT}" )
tmux bind M-c run "$PLUG_ROOT/scripts/tmux-clockette.sh" 
tmux run-shell -b "$PLUG_ROOT/scripts/tmux-clockette.sh"
tmux setenv -u '@PLUG_ROOT'
