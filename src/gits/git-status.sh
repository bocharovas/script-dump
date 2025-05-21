#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

REPO_COUNT=0

for dir in "$HOME"/* "$HOME/projects"/*; do
    [ -d "$dir" ] || continue

    if [ -d "$dir/.git" ]; then
        CHANGES=$(git --git-dir="$dir/.git" --work-tree="$dir" status --porcelain)
        NAME=$(basename "$dir")
        BRANCH=$(git --git-dir="$dir/.git" --work-tree="$dir" rev-parse --abbrev-ref HEAD)

        upstream=$(git --git-dir="$dir/.git" --work-tree="$dir" rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null)
        TRACKING_STATUS="${YELLOW}(no upstream)${RESET}"

        if [ -n "$upstream" ]; then
            git --git-dir="$dir/.git" --work-tree="$dir" fetch --quiet

            counts=$(git --git-dir="$dir/.git" --work-tree="$dir" rev-list --left-right --count HEAD..."$upstream")
            ahead=$(echo "$counts" | cut -f1)
            behind=$(echo "$counts" | cut -f2)

            if [ "$ahead" -eq 0 ] && [ "$behind" -eq 0 ]; then
                TRACKING_STATUS="${GREEN}up to date with $upstream${RESET}"
            elif [ "$ahead" -gt 0 ] && [ "$behind" -eq 0 ]; then
                TRACKING_STATUS="${CYAN}ahead of $upstream by $ahead commit(s)${RESET}"
            elif [ "$ahead" -eq 0 ] && [ "$behind" -gt 0 ]; then
                TRACKING_STATUS="${RED}behind $upstream by $behind commit(s)${RESET}"
            else
                TRACKING_STATUS="${RED}diverged from $upstream (ahead $ahead, behind $behind)${RESET}"
            fi
        fi

	if command -v gh >/dev/null 2>&1; then
	    PR_LIST=$(cd "$dir" && gh pr list --json title,url --jq '.[] | "- \(.title) [\(.url)]"' 2>/dev/null)

            if [ -n "$PR_LIST" ]; then
                PR_STATUS="${GREEN}Open PRs:${RESET}\n$PR_LIST"
            else
                PR_STATUS="${YELLOW}No open PRs${RESET}"
            fi
        else
            PR_STATUS="${CYAN}(gh not installed)${RESET}"
        fi


        if echo "$dir" | grep -q "^$HOME/projects"; then
            PREFIX=">>>"
            SUFFIX="<<<"
        else
            PREFIX="==="
            SUFFIX="==="
        fi

        REPO_COUNT=$((REPO_COUNT + 1))

        echo "$PREFIX $NAME [$BRANCH] — $TRACKING_STATUS $SUFFIX — $PR_STATUS"

        if [ -n "$CHANGES" ]; then
            echo "$CHANGES"
        else
            echo "${YELLOW}No changes${RESET}"
        fi

        echo
    fi
done

echo "Total repositories: $REPO_COUNT"

if command -v gh >/dev/null 2>&1; then
    REMOTE_COUNT=$(gh repo list --limit 1000 --json name --jq 'length' 2>/dev/null)
    echo "${GREEN}Total remote repositories: $REMOTE_COUNT${RESET}"
else
    echo "${RED}GitHub CLI (gh) not installed — cannot list remote repositories.${RESET}"
fi
