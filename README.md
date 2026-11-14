# macOS screenshot organizer

Petit script Bash qui range les captures d'écran macOS dans un dossier par jour.

Il repère la date dans le nom du fichier, en français ou en anglais (`Capture d’écran 2026-02-27 at 11.58.50.png`, `Screenshot 2026-02-27 at 11.58.50.png`), crée un dossier par date et y déplace la capture. Les fichiers sans date valide ne sont pas touchés, et les captures déjà présentes sont traitées aussi.

Avant :

```
Capture d’écran 2026-02-27 at 11.58.50.png
Capture d’écran 2026-02-27 at 14.10.12.png
Capture d’écran 2026-02-26 at 18.02.01.png
```

Après :

```
27-02-2026/
26-02-2026/
organize_screens.sh
```

## Utilisation

Copier le script dans le dossier des captures (par exemple Bureau), puis :

```bash
chmod +x organize_screens.sh
./organize_screens.sh
```

Options :

| Option | Effet |
| --- | --- |
| `-d dossier` | range ce dossier au lieu de celui du script |
| `-f fr` ou `-f iso` | dossiers en `JJ-MM-AAAA` (défaut) ou `AAAA-MM-JJ` |
| `-n` | simulation : affiche ce qui serait déplacé, sans rien toucher |

Un fichier déjà présent dans le dossier du jour n'est jamais écrasé, et une date impossible (mois 13, par exemple) laisse le fichier en place.

## Tests

```bash
./test/run.sh
```

Chaque cas tourne dans un dossier temporaire. La CI lance aussi ShellCheck.
