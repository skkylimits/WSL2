# 🧠 Gemini CLI – The Terminal Superpower Cheat Sheet

---

## ⚙️ INSTALLATION

```bash
# Linux / WSL
pnpm install -g @google/gemini-cli

# macOS
brew install gemini-cli
```

👉 Als installatie faalt, herhaal met `sudo`.

---

## 🧩 BASIC USAGE

```bash
mkdir coffee-project
cd coffee-project
gemini
```

> 🟢 Start Gemini CLI (werkt op macOS, Linux, Windows WSL2).

Bij eerste start:

* Je logt in met je **Google-account** (ook gratis Gmail werkt).
* Terminal opent automatisch je browser voor login.
* Daarna zie je model: `Gemini 2.5 Pro`.

---

## 💬 ASK QUESTIONS

```bash
How do I make the best cup of coffee in the world?
```

Gemini geeft direct een antwoord in de terminal.

💡 **Extra voordeel**: in de terminal zie je o.a.

* `[Gemini 2.5 Pro]`
* `99% context left` (de overgebleven context-windowruimte)

---

## 🧱 FILE ACCESS & CREATION

Gemini CLI kan **lezen en schrijven** in je projectdirectory.

Voorbeeld:

```bash
Create a document named BestCoffeeMethod.md summarizing the best methods.
```

Gemini zal vragen:

```
Do you want me to create a file for you? (Y/n)
```

→ typ `y` → het schrijft echt naar schijf.

Check:

```bash
ls
cat BestCoffeeMethod.md
```

---

## 🪄 CONTEXT & MEMORY SYSTEM

### 📁 `gemini.md`

Elke map krijgt z’n eigen contextbestand:

```bash
/
```

> Typ alleen `/` in Gemini → dit **genereert automatisch `gemini.md`** in je huidige map.

```bash
cat gemini.md
```

📘 **Wat erin staat:**

* Beschrijving van je project
* Samenvatting van recente interacties
* Relevante bestanden
* Voortgang

Gemini gebruikt dit bestand **automatisch als context** bij elke nieuwe sessie in die map.

---

## 🔁 PERSISTENT CONTEXT

Als je opnieuw start:

```bash
gemini
```

Dan zie je:

```
100% context left (using gemini.md)
```

💡 Je hoeft nooit meer opnieuw uit te leggen waar je mee bezig bent.
Alle projectkennis zit in `gemini.md`.

> “No more 20 scattered chats — everything lives in this one file.”

---

## ⚒️ BUILT-IN TOOLS

In Gemini type je:

```bash
/tools
```

→ toont alle beschikbare functies (“read file”, “write file”, “bash”, “python”, enz.).
Je kunt zelfs **nieuwe tools toevoegen**.

---

## 🧩 FILE-AWARE AI (SUPERPOWER)

Gemini kan:

* `read` / `write` bestanden in de folder
* `analyze` scripts
* `run` bash of Python-code direct vanuit chat

Voorbeeld:

```bash
Run a Python script that prints the project summary.
```

---

## 🧱 PROJECT-INTELLIGENCE

Gemini creëert contextinstructies voor zichzelf via `gemini.md`.

Elke keer dat je `/` typt, wordt `gemini.md` **geüpdatet met nieuwe inzichten**:

```bash
### Update: 2025-10-28
- Added Docker setup
- Generated BestCoffeeMethod.md
- Planned Coffee Blog outline
```

Nieuwe sessie?

```bash
gemini
```

→ Gemini laadt `gemini.md` → weet direct waar je bent gebleven.

---

## 🧠 EXAMPLES

| Doel                     | Commando of actie                                            |
| ------------------------ | ------------------------------------------------------------ |
| Start AI in huidige map  | `gemini`                                                     |
| Vraag stellen            | `how do I...`                                                |
| Toon tools               | `/tools`                                                     |
| Genereer context         | `/`                                                          |
| Bekijk context           | `cat gemini.md`                                              |
| Nieuw project            | `mkdir myproj && cd myproj && gemini`                        |
| Laat AI file schrijven   | `create README.md describing this project`                   |
| Persistente sessie       | open Gemini opnieuw in dezelfde map                          |
| Update context handmatig | `update-gemini "added docker support"` (custom bash functie) |

---

## 🔐 SECURITY WARNING

> Gemini CLI heeft **lees- en schrijfrechten** in je lokale map.
> Gebruik **Zero Trust** (zoals TwinGate) als je werkt met gevoelige projecten of labnetwerken.

---

## 💡 WHY IT’S POWERFUL

| Browser Gemini               | Terminal Gemini                  |
| ---------------------------- | -------------------------------- |
| Beperkte context (verborgen) | Context zichtbaar en beheersbaar |
| Geen toegang tot files       | Kan lokaal lezen/schrijven       |
| Sessies verdwijnen           | Context persistent per project   |
| Geen automation              | Kan bash/python uitvoeren        |
| Vast in sandbox              | Volledige OS-integratie          |

---

## 🪶 TL;DR – GEMINI CLI IN ONE SENTENCE

> Gemini CLI breekt AI uit de browser:
> het leeft in je terminal, begrijpt je projectmappen, onthoudt alles in `gemini.md`,
> schrijft en leest bestanden, en groeit mee met je code — alsof ChatGPT in je shell woont.

---

Wil je dat ik nu een **Gemini AI bootstrapper** maak (zoals `gemini-init.sh`, maar uitgebreid met automatisch `/`-triggeren, logging naar `gemini.md`, en instant `/tools` setup)?
Dan hoef je alleen `bash gemini-bootstrap.sh` te draaien en je hele project krijgt instant AI-context + file-awareness.


| Stap                        | Wat je doet                                                    | Wat er gebeurt                                             |
| --------------------------- | -------------------------------------------------------------- | ---------------------------------------------------------- |
| 🧩 **1. Installeren**       | `curl -fsSL https://cli.gemini.dev/install.sh \| bash`         | Installeert de Gemini command-line interface.              |
| 📂 **2. Project starten**   | `mkdir myproject && cd myproject`                              | Elke map is een eigen *context*.                           |
| 💬 **3. Starten**           | `gemini`                                                       | Opent AI-chat direct in terminal.                          |
| 🔐 **4. Inloggen**          | Log in met je Google-account                                   | Gratis tier via Gemini 2.5 Pro.                            |
| ✍️ **5. Vraag stellen**     | Typ een vraag (“How to make coffee?”)                          | Gemini antwoordt in terminal.                              |
| 💾 **6. Context genereren** | Typ `/` → enter                                                | Maakt `gemini.md` file (project-context).                  |
| 🧠 **7. Persistentie**      | Elke nieuwe sessie in die map herkent automatisch `gemini.md`. | Geen herhaalde uitleg nodig — context blijft.              |
| ⚙️ **8. File-power**        | Gemini kan *lezen/schrijven* in je lokale files.               | Je kunt taken geven als “maak README.md met samenvatting”. |
