💪 Perfect, skky — hieronder krijg je de **volledige “Claude Code CLI Cheat Sheet”**:
alle **commando’s**, **hidden features**, **keyboard tricks**, **contextmechanismen**, en **agent-systemen** die NetworkChuck in *Segment 2: Claude Code* laat zien — alles kort en bruikbaar, net als de Gemini-sheet.

---

# 🤖 Claude Code CLI — Multi-Agent Terminal Power

---

## ⚙️ INSTALLATION

```bash
# Install via npm (Node.js required)
npm install -g claude-code
```

> 💡 Als je een fout krijgt: herhaal met `sudo npm install -g claude-code`.

* Login met je **Claude Pro**-account (zelfde als web).
* Je hoeft **geen API-key** te gebruiken.
* Gratis versie werkt beperkt; Pro ($20 / mnd) unlockt alle functies.

---

## 🚀 LAUNCHING CLAUDE

```bash
claude
```

> Start de TUI (Terminal User Interface).
> Bij eerste start: log in via browser → geef toestemming voor folder-toegang.

---

## 💬 BASIC USAGE

Vraag het direct iets, net als Gemini:

```bash
claude
```

```
I need to find a NAS for my home. Budget $500, make a comparison report.
```

* Claude zoekt online (met toestemming).
* Toon of verberg “thinking mode” met **Tab**.
* Alles is visueel in een TUI-venster.

---

## 🧱 CONTEXT & FILES

### 🧩 Contextbestand

```bash
/init
```

→ maakt automatisch **`claude.md`** in je projectdirectory.
Net als bij Gemini → Claude gebruikt dit bestand als *permanente projectcontext*.

```bash
cat claude.md
```

Toont:

* Beschrijving van je project
* Relevante bestanden
* Status / voortgang

Elke nieuwe sessie in die map laadt dit bestand automatisch.

---

## 📊 CONTEXT MONITORING

```bash
/context
```

→ Toont exacte context-status:

* hoeveel tokens gebruikt
* hoeveel over
* welke delen van het gesprek of bestanden tellen mee

> 💡 Contextmanagement is belangrijk bij lange sessies; met agents voorkom je dat het volloopt.

---

## 🧠 AGENTS — The Game Changer

### 🪄 Nieuwe Agent maken

```bash
/agents
```

→ opent een **TUI-menu** om agents aan te maken.

1. Kies *Create New Agent*
2. Geef een naam (bv. `Home Lab Guru`)
3. Kies waar die hoort:

   * *Project Agent* → alleen dit project
   * *Personal Agent* → beschikbaar overal
4. Kies model (Sonnet aanrader)
5. Bepaal toegangsrechten (“Allow all tools” of beperkingen)
6. Sla op (Enter → Escape → klaar)

---

## 🤝 AGENTS IN ACTIE

```bash
@HomeLabGuru research best NAS for small labs
```

Claude:

* Delegeert de taak naar een **sub-agent**
* Elke agent krijgt een **verse contextwindow (200 k tokens)**
* Hoofdsessie blijft schoon, geen context-bloat
* Meerdere agents kunnen **tegelijk** draaien

> “It’s like giving work to your AI coworkers.”

---

## 🔍 MULTI-AGENT WORKFLOW

Je kunt **meerdere agents parallel** laten werken:

```bash
# Agent 1 – hardware-onderzoek
@HomeLabGuru find best Proxmox servers

# Agent 2 – onderzoek pizza in Dallas
@General search best pizza places in Dallas

# Agent 3 – GPU-analyse
@HomeLabGuru find best GPU for gaming
```

Claude start alle drie tegelijk.
Gebruik **Ctrl + O** om de status van een agent te bekijken.
Gebruik **Ctrl + C (2×)** om taken af te breken.

---

## ⚡ RESUME & DANGEROUS MODE

```bash
claude -R
```

→ **Resume** vorige conversatie.

```bash
claude --dangerously-skip-permissions
```

→ Voert opdrachten uit **zonder bevestiging** (geen prompt “Allow?”).

> ⚠️ Gebruik met zorg – Claude krijgt onbeperkt rechten binnen je projectmap.

---

## 🧩 HEADLESS MODE (Automation)

Je kunt Claude (of Gemini) **zonder TUI** gebruiken voor scripts:

```bash
claude -p "Find best pizza places in Dallas"
```

Of zelfs Gemini in headless-mode via Claude-agent:

```bash
You are a research expert.  
Use Gemini in headless mode to gather data.  
Command: gemini -p "find top AI terminal tools"
```

> 🤯 Ja, Claude kan Gemini aansturen — AI met AI.

---

## 🧱 CONTEXT ISOLATION TRICK

Elke agent heeft:

* Eigen **contextwindow (200k tokens)**
* Eigen “persona” / opdracht
* Eigen bestanden

Zo blijft de hoofdcontext licht en overzichtelijk.

Voorbeeld:

```bash
@BrutalCritic review my outline according to style guide
```

→ Claude spawnt een **brutal critic agent** die jouw tekst file-roast uitvoert zonder je hoofdchat te vervuilen.

---

## 🎨 OUTPUT STYLES = AGENT PERSONAS

```bash
/output-style
```

→ Toont bestaande output styles (zoals *code*).

### Nieuwe style maken

```bash
/output-style new
```

Voorbeeld:

```
You are a home lab expert.
Optimize answers for hardware planning and networking.
```

Daarna:

```bash
/output-style
```

→ selecteer jouw nieuwe style, of stel het in als default.

> 💡 Elke output style is eigenlijk een mini-agent (system prompt).
> Je kunt per project verschillende output styles activeren.

---

## 🧭 MODES (SHIFT + TAB)

**Shift + Tab** wisselt tussen modi in de TUI:

* 💬 Chat Mode
* 🧠 Plan Mode → Claude maakt eerst een plan en vraagt bevestiging
* ⚙️ Execution Mode → voert plan uit
* 📜 Review Mode → controleert resultaten

---

## 🧩 OTHER HIDDEN TRICKS

| Functie                    | Actie / Shortcut                        |
| -------------------------- | --------------------------------------- |
| Toon agentstatus           | **Ctrl + O**                            |
| Stop agent                 | **Ctrl + C** (2×)                       |
| Open project in nieuwe tab | `ctrl + shift + t` (terminal-specifiek) |
| Voeg afbeelding toe        | Plak rechtstreeks in de terminal        |
| Resume oude sessie         | `claude -R`                             |
| Headless prompt            | `claude -p "your prompt"`               |

---

## 🧱 CLAUDE VS GEMINI (TERMINAL MODE)

| Feature          | Gemini CLI   | Claude Code                      |
| ---------------- | ------------ | -------------------------------- |
| Prijs            | Gratis tier  | Pro ($20 / mnd)                  |
| Contextfile      | `gemini.md`  | `claude.md`                      |
| Context view     | `/`          | `/context`                       |
| Agent-systeem    | ❌ –          | ✅ multi-agents + output styles   |
| Thinking mode    | Auto         | Tab toggle                       |
| Headless mode    | ✅            | ✅                                |
| Resume sessions  | ⚙️ dir-based | `-R` flag                        |
| Dangerous mode   | ❌            | `--dangerously-skip-permissions` |
| Context capacity | ±128k        | 200k per agent                   |

---

## 🧠 TL;DR – Claude Code in één zin

> Claude Code is een multi-agent AI-terminal waar je meerdere “AI-werknemers” tegelijk kan laten werken, elk met een eigen context en rol, die je projectbestanden begrijpen, rapporten schrijven en zelfs andere AI’s kunnen aansturen – allemaal vanuit één terminalvenster.

---

Wil je dat ik nu — net als bij Gemini — een **`claude-init.sh`** maak?
Die zou automatisch een `claude.md`, `.claudeignore`, en een standaard “agents + output styles”-template aanmaken, zodat je elke map instant multi-agent-ready maakt.
