#!/usr/bin/env bash

current_path=$(tmux display-message -p -F "#{pane_current_path}")

is_git_dir() {
  gitcp="git -C $current_path"
  if [ "$($gitcp rev-parse --abbrev-ref HEAD)" != "" ]; then
    echo "true"
  else
    echo "false"
  fi
  return
}

main() {
  if [ $(is_git_dir) == "true" ]; then
    gitcp="git -C $current_path"
    
    git_status+="$($gitcp status -s | rg "M" | wc -l | awk '{if ($1 > 0) print $1"! "}')"
    git_status+="$($gitcp status -s | rg "A" | wc -l | awk '{if ($1 > 0) print $1"+ "}')"
    git_status+="$($gitcp status -s | rg "\?" | wc -l | awk '{if ($1 > 0) print $1"? "}')"
    git_status+="$($gitcp status -s | rg "R" | wc -l | awk '{if ($1 > 0) print $1"~ "}')"
    git_status+="$($gitcp status -s | rg "D" | wc -l | awk '{if ($1 > 0) print $1"- "}')"

    if [[ git_status != "" ]]; then
      branch="#[fg=#d65d0e] $($gitcp branch --show-current) $(echo "$git_status" | awk '{$1=$1};1')"
    else
      branch="#[fg=#98971a]$($gitcp branch --show-current)"
    fi
    echo "$branch"
  else
    echo ""
  fi
  return
}

main
