#!/bin/sh

REPO_COUNT=0

for dir in "$HOME"/* "$HOME/projects"/*; do
    if [ -d "$dir/.git" ]; then
        CHANGES=$(git --git-dir="$dir/.git" --work-tree="$dir" status --porcelain)
        NAME=$(basename "$dir")
        BRANCH=$(git --git-dir="$dir/.git" --work-tree="$dir" rev-parse --abbrev-ref HEAD)

        # Проверяем upstream ветку
        upstream=$(git --git-dir="$dir/.git" --work-tree="$dir" rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null)

        # По умолчанию статус трекинга пуст
        TRACKING_STATUS="(no upstream)"

        if [ -n "$upstream" ]; then
            # Обновим инфо с удалённого, чтобы было актуально (тихо)
            git --git-dir="$dir/.git" --work-tree="$dir" fetch --quiet

            counts=$(git --git-dir="$dir/.git" --work-tree="$dir" rev-list --left-right --count HEAD..."$upstream")
            ahead=$(echo "$counts" | cut -f1)
            behind=$(echo "$counts" | cut -f2)

            if [ "$ahead" -eq 0 ] && [ "$behind" -eq 0 ]; then
                TRACKING_STATUS="up to date with $upstream"
            elif [ "$ahead" -gt 0 ] && [ "$behind" -eq 0 ]; then
                TRACKING_STATUS="ahead of $upstream by $ahead commit(s)"
            elif [ "$ahead" -eq 0 ] && [ "$behind" -gt 0 ]; then
                TRACKING_STATUS="behind $upstream by $behind commit(s)"
            else
                TRACKING_STATUS="diverged from $upstream (ahead $ahead, behind $behind)"
            fi
        fi

        if echo "$dir" | grep -q "^$HOME/projects"; then
            PREFIX=">>>"
            SUFFIX="<<<"
        else
            PREFIX="==="
            SUFFIX="==="
        fi

        REPO_COUNT=$((REPO_COUNT + 1))

        echo "$PREFIX $NAME [$BRANCH] — $TRACKING_STATUS $SUFFIX"

        if [ -n "$CHANGES" ]; then
            echo "$CHANGES"
        else
            echo "No changes"
        fi

        echo
    fi
done

echo "Total repositories: $REPO_COUNT"
