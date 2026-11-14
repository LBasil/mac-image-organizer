#!/bin/bash
# Range les captures d'écran macOS dans un dossier par jour.
#
# Usage : ./organize_screens.sh [-d dossier] [-f fr|iso] [-n]
#   -d  dossier à ranger (par défaut : le dossier du script)
#   -f  format des dossiers : fr = JJ-MM-AAAA (défaut), iso = AAAA-MM-JJ
#   -n  simulation : affiche ce qui serait fait sans rien déplacer
#
# Compatible avec bash 3.2 (celui de macOS).

FORMAT="fr"
DRY_RUN=0
TARGET_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
    sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'
}

while getopts "d:f:nh" opt; do
    case "$opt" in
        d) TARGET_DIR="$OPTARG" ;;
        f) FORMAT="$OPTARG" ;;
        n) DRY_RUN=1 ;;
        h) usage; exit 0 ;;
        *) usage; exit 2 ;;
    esac
done

if [ "$FORMAT" != "fr" ] && [ "$FORMAT" != "iso" ]; then
    echo "Format inconnu : $FORMAT (attendu : fr ou iso)" >&2
    exit 2
fi

cd "$TARGET_DIR" || { echo "Dossier introuvable : $TARGET_DIR" >&2; exit 1; }

moved=0
skipped=0

for file in *.png; do
    [ -e "$file" ] || continue

    # Date AAAA-MM-JJ dans le nom du fichier.
    date=$(echo "$file" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -n 1)
    year=${date%%-*}
    rest=${date#*-}
    month=${rest%%-*}
    day=${rest#*-}

    # Ignorer les fichiers sans date ou avec une date impossible (mois 13, jour 45...).
    if [ -z "$date" ] || [ "$((10#$month))" -lt 1 ] || [ "$((10#$month))" -gt 12 ] \
        || [ "$((10#$day))" -lt 1 ] || [ "$((10#$day))" -gt 31 ]; then
        skipped=$((skipped + 1))
        continue
    fi

    if [ "$FORMAT" = "fr" ]; then
        folder="$day-$month-$year"
    else
        folder="$date"
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        echo "$file -> $folder/"
    else
        mkdir -p "$folder"
        # -n : ne jamais écraser un fichier déjà présent dans le dossier de destination.
        if [ -e "$folder/$file" ]; then
            skipped=$((skipped + 1))
            continue
        fi
        mv -n "$file" "$folder/"
    fi
    moved=$((moved + 1))
done

if [ "$DRY_RUN" -eq 1 ]; then
    echo "Simulation : $moved fichier(s) seraient rangés, $skipped ignoré(s)."
else
    echo "Terminé : $moved fichier(s) rangé(s), $skipped ignoré(s)."
fi
