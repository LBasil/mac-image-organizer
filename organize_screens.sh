#!/bin/bash

FORMAT="fr"

cd "$(dirname "$0")" || exit

for file in *.png; do
    [ -e "$file" ] || continue

    # Extraire la date depuis le nom
    date=$(echo "$file" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')

    [ -z "$date" ] && continue

    if [ "$FORMAT" = "fr" ]; then
        folder=$(echo "$date" | awk -F- '{print $3"-"$2"-"$1}')
    else
        folder="$date"
    fi

    mkdir -p "$folder"
    mv "$file" "$folder/"
done

echo "Organisation terminée ✅"