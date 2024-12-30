#!/usr/bin/env bash

## ---------------------------- ##
## Insired by 2KAbhishek/tmux2k ##
## ---------------------------- ##

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

aw_color="#458588"
aw_fg="#282828"

reset_options() {
  ts="tmux set-option"

  $ts -g status-style "bg=#282828"
  $ts -g status-left-length 100
  $ts -g status-right-length 100
  $ts -g status-left ""
  $ts -g status-right ""
  tmux set -g status-justify "centre"
}

working_dir() {
  git_root=$(git rev-parse --show-toplevel)
  echo "$(basename $git_root)"
  return
}

set_status() {
  ts="tmux set-option"
  possible_separators="╱(\diagup)(nf-ple-forward)"

  $ts -ga status-style "bg=#282828"

  l_delim="#[fg=#3c3836] \\"
  r_delim="#[fg=#3c3836]/ "
  git_changes="$($current_dir/git.sh)"
  $ts -ga status-left " #[fg=#b16286, bold]#S$l_delim#[fg=#98971a]"
  $ts -ga status-right "$git_changes $r_delim#[fg=#98971a, bold]%H:%M "
}

set_window() {
  ts="tmux set-window-option"

  $ts -g window-status-current-format \
    "#[fg=$aw_color,bg=$aw_fg]#[fg=$aw_fg,bg=$aw_color,bold]#I:#W#[fg=$aw_color,bg=$aw_fg]"

  $ts -g window-status-format \
    "#[fg=$aw_color,bg=$aw_fg]#I:#W"
}

main() {
  reset_options
  set_status
  set_window
}

main
