#!/bin/sh

# Инициализация счётчика репозиториев
REPO_COUNT=0

for dir in "$HOME"/* "$HOME/projects"/*; do
    if [ -d "$dir/.git" ]; then
        CHANGES=$(git --git-dir="$dir/.git" --work-tree="$dir" status --porcelain)
        NAME=$(basename "$dir")
        BRANCH=$(git --git-dir="$dir/.git" --work-tree="$dir" rev-parse --abbrev-ref HEAD)

        # Для репозиториев в папке projects
        if echo "$dir" | grep -q "^$HOME/projects"; then
            PREFIX=">>>"
            SUFFIX="<<<"
        else
            PREFIX="==="
            SUFFIX="==="
        fi

        # Увеличиваем счётчик репозиториев
        REPO_COUNT=$((REPO_COUNT + 1))

        if [ -n "$CHANGES" ]; then
            echo "$PREFIX $NAME [$BRANCH] $SUFFIX"
            echo "$CHANGES"
        else
            echo "$PREFIX $NAME [$BRANCH] $SUFFIX"
            echo "No changes"
        fi
        echo
    fi
done

# Выводим общее количество репозиториев
echo "Total repositories: $REPO_COUNT"
