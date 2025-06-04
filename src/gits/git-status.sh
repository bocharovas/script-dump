#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BLUE='\033[0;96m'
RESET='\033[0m'

REPO_COUNT=0

for dir in "$HOME"/* "$HOME/projects"/*; do
  [ -d "$dir" ] || continue
  [ "$dir" = "$HOME/projects/modbus-dotnet" ] && continue

  if [ -d "$dir/.git" ]; then
    changes=$(git --git-dir="$dir/.git" --work-tree="$dir" status --porcelain)
    name=$(basename "$dir")
    branch=$(git --git-dir="$dir/.git" --work-tree="$dir" rev-parse --abbrev-ref HEAD)
    stages=$(git --git-dir="$dir/.git" --work-tree="$dir" stash list)
    upstream=$(git --git-dir="$dir/.git" --work-tree="$dir" rev-parse --abbrev-ref \
      --symbolic-full-name @{upstream} 2>/dev/null)
    tracking_status="${YELLOW}(no upstream)${RESET}"
    branches=$(git --git-dir="$dir/.git" --work-tree="$dir" branch -a)

    if [ -n "$upstream" ]; then
      git --git-dir="$dir/.git" --work-tree="$dir" fetch --quiet
      counts=$(git --git-dir="$dir/.git" --work-tree="$dir" rev-list --left-right --count HEAD..."$upstream")
      ahead=$(echo "$counts" | cut -f1)
      behind=$(echo "$counts" | cut -f2)

      if [ "$ahead" -eq 0 ] && [ "$behind" -eq 0 ]; then
        tracking_status="${GREEN}up to date with $upstream${RESET}"
      elif [ "$ahead" -gt 0 ] && [ "$behind" -eq 0 ]; then
        tracking_status="${CYAN}ahead of $upstream by $ahead commit(s)${RESET}"
      elif [ "$ahead" -eq 0 ] && [ "$behind" -gt 0 ]; then
        tracking_status="${RED}behind $upstream by $behind commit(s)${RESET}"
      else
        tracking_status="${RED}diverged from $upstream (ahead $ahead, behind $behind)${RESET}"
      fi
    fi

  if command -v gh >/dev/null 2>&1; then
    pr_list=$(cd "$dir" && gh pr list --json title,url --jq '.[] | "- \(.title) [\(.url)]"' 2>/dev/null)

    if [ -n "$pr_list" ]; then
      pr_status="${GREEN}open pr:${RESET}\n$pr_list"
    else
      pr_status="${YELLOW}no open pr${RESET}"
    fi

  else
    pr_status="${CYAN}(gh not installed)${RESET}"
  fi

  if echo "$dir" | grep -q "^$HOME/projects"; then
    PREFIX=">>>"
    SUFFIX="<<<"
  else
    PREFIX="==="
    SUFFIX="==="
  fi

  repo_count=$((repo_count + 1))

  echo "$PREFIX $name [$branch] — $tracking_status $SUFFIX — $pr_status"

  if [ -n "$changes" ]; then
    echo "$changes"
  else
    echo "${YELLOW}no changes${RESET}"
  fi

  if [ -n "$stages" ]; then
    echo "${MAGENTA}$stages${RESET}"
  fi

  if [ -n "$branches" ]; then
    echo "${BLUE}$branches${RESET}"
  fi
fi  
done

echo "Total repositories: $repo_count"

if command -v gh >/dev/null 2>&1; then
  remote_count=$(gh repo list --limit 1000 --json name --jq 'length' 2>/dev/null)
  echo "${GREEN}Total remote repositories: $remote_count${RESET}"
else
  echo "${RED}GitHub CLI (gh) not installed — cannot list remote repositories.${RESET}"
fi

