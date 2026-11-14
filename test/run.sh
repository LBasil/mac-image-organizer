#!/bin/bash
# Tests du script : chaque cas travaille dans un dossier temporaire.
set -u
SCRIPT="$(cd "$(dirname "$0")/.." && pwd)/organize_screens.sh"
fail=0

check() { # nom, condition (code retour)
    if [ "$2" -eq 0 ]; then echo "ok   - $1"; else echo "FAIL - $1"; fail=1; fi
}

new_dir() { d=$(mktemp -d); echo "$d"; }

# 1. Rangement par défaut (format fr), français et anglais.
d=$(new_dir)
touch "$d/Capture d’écran 2026-02-27 at 11.58.50.png" "$d/Screenshot 2026-02-26 at 18.02.01.png"
"$SCRIPT" -d "$d" >/dev/null
[ -f "$d/27-02-2026/Capture d’écran 2026-02-27 at 11.58.50.png" ]; check "format fr, nom français" $?
[ -f "$d/26-02-2026/Screenshot 2026-02-26 at 18.02.01.png" ]; check "format fr, nom anglais" $?

# 2. Format iso.
d=$(new_dir); touch "$d/Screenshot 2026-02-27 at 11.png"
"$SCRIPT" -d "$d" -f iso >/dev/null
[ -f "$d/2026-02-27/Screenshot 2026-02-27 at 11.png" ]; check "format iso" $?

# 3. Fichiers sans date ou avec une date impossible : non touchés.
d=$(new_dir); touch "$d/photo.png" "$d/Screenshot 2026-13-45 at 11.png"
"$SCRIPT" -d "$d" >/dev/null
[ -f "$d/photo.png" ] && [ -f "$d/Screenshot 2026-13-45 at 11.png" ]; check "sans date ou date invalide ignorés" $?

# 4. Simulation : rien ne bouge.
d=$(new_dir); touch "$d/Screenshot 2026-02-27 at 11.png"
out=$("$SCRIPT" -d "$d" -n)
[ -f "$d/Screenshot 2026-02-27 at 11.png" ] && [ ! -d "$d/27-02-2026" ]; check "simulation sans effet" $?
echo "$out" | grep -q "27-02-2026"; check "simulation affiche la destination" $?

# 5. Un fichier déjà présent à destination n'est jamais écrasé.
d=$(new_dir); mkdir "$d/27-02-2026"
echo "ancien" > "$d/27-02-2026/Screenshot 2026-02-27 at 11.png"
echo "nouveau" > "$d/Screenshot 2026-02-27 at 11.png"
"$SCRIPT" -d "$d" >/dev/null
[ "$(cat "$d/27-02-2026/Screenshot 2026-02-27 at 11.png")" = "ancien" ] && [ -f "$d/Screenshot 2026-02-27 at 11.png" ]; check "pas d'écrasement" $?

# 6. Option invalide : code de sortie non nul.
"$SCRIPT" -f xx >/dev/null 2>&1; [ $? -ne 0 ]; check "format invalide refusé" $?

exit $fail
