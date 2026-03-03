# 📸 macOS Screenshot Organizer

A simple Bash script to automatically organize your macOS screenshots into folders by date.

Works with default macOS screenshot names, for example:

Capture d’écran 2026-02-27 at 11.58.50.png  
Screenshot 2026-02-27 at 11.58.50.png

---

## ✨ Features

- 📅 Automatically detects the date (YYYY-MM-DD) in the filename  
- 📁 Creates a folder for each day  
- 🇫🇷 Optional French date format (DD-MM-YYYY)  
- 🌍 Compatible with macOS in any language (FR / EN)  
- 🔁 Works retroactively on existing screenshots  
- 🛡️ Only affects files containing a valid date  

---

## 📂 Example

Before:

Capture d’écran 2026-02-27 at 11.58.50.png  
Capture d’écran 2026-02-27 at 14.10.12.png  
Capture d’écran 2026-02-26 at 18.02.01.png

After:

27-02-2026/  
26-02-2026/  
organize_screens.sh

---

## 🚀 Installation

1. Place the script in the folder containing your screenshots (for example, Desktop/Images)  
2. Make it executable:  
chmod +x organize_screens.sh  
3. Run it:  
./organize_screens.sh

---

## ⚙️ Configuration

You can change the folder date format in the script:

FORMAT="fr"   # DD-MM-YYYY  
or  
FORMAT="iso"  # YYYY-MM-DD

---

## 🧠 How it works

The script:

1. Loops through all `.png` files  
2. Extracts the date using regex (YYYY-MM-DD)  
3. Creates a corresponding folder  
4. Moves the file into the folder

It works regardless of macOS language, special characters, or accents.

---

## 📌 Compatibility

- macOS  
- Bash  
- No external dependencies  

---

## 🔮 Possible improvements

- Dry run / preview mode  
- Automatic organization via Automator  
- Node.js version  
- Recursive organization  

---

## 📜 License

MIT — do whatever you want with it 😄
