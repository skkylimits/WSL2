# 🧠 Meta-Proof Workflow — AI Project Syncing & Self-Review Cheat Sheet

---

## 🧩 OVERVIEW

NetworkChuck’s *Meta-Proof* workflow shows how his **Claude**, **Gemini**, and **Codex (GPT)** context files sync together into one self-managing project system.
Everything — summaries, progress, and critiques — lives as **local files + agents**.

---

## ⚙️ DAILY END-OF-DAY FLOW

### 1️⃣ Session Closer Agent

When he’s done working, Chuck runs:

```bash
run @session-closer
```

This **agent** (a `.md` file in `/agents/script-session-closer.md`) performs:

| Stap                          | Actie                                                |
| ----------------------------- | ---------------------------------------------------- |
| 🧠 **Collect summary**        | Bundelt alle gesprekken & beslissingen van de dag    |
| 🗒 **Update session summary** | Schrijft naar `session-summary.md`                   |
| 🔁 **Sync context**           | Update `claude.md`, `gemini.md`, en `agents.md`      |
| 🧩 **Project housekeeping**   | Controleert of core project-files gewijzigd zijn     |
| 🧷 **Commit to GitHub**       | `git add . && git commit -m "Session close summary"` |

> 💡 Alles wat je doet — zelfs gesprekken — krijgt versiebeheer via Git.
> Je kunt terug in tijd, zien wat je dacht, en waarom je iets veranderde.

---

## 🧱 WHY GIT MATTERS

> “I treat every idea and script like code.”

Hij gebruikt GitHub niet alleen voor code, maar ook voor **ideeën, scripts en AI-output**.
Elke sessie-commit = een snapshot van zijn denkproces.

Voordelen:

* Automatische documentatie
* Volledige projectgeschiedenis
* Herstelpunt bij fouten

---

## 💬 SELF-CRITIC SYSTEM — “The Brutal Critic”

Naast creëren, gebruikt hij AI om zichzelf te **roasten**.
In zijn `/agents/`-map staat bijvoorbeeld:

```bash
agents/brutal-critic.md
```

**Wat doet die agent?**

* Leest je script of outputbestand
* Analyseert volgens zijn eigen frameworks (“style”, “audience”, “structure”)
* Beoordeelt van 1–10 en motiveert de score
* Heeft meerdere “persoonlijkheden” (3 reviewers tegelijk)

💬 Voorbeeld:

```bash
run @brutal-critic review script.md
```

⚙️ Werking:

* Leest context uit `claude.md` & framework-docs
* Vermijdt bias (frisse sessie, geen lopende context)
* Geeft harde, eerlijke feedback

> “When it says I did a good job, I *know* it’s good.”

---

## 🧠 SELF-IMPROVEMENT LOOP

| Fase             | Tool                  | Functie                   |
| ---------------- | --------------------- | ------------------------- |
| 🧩 **Ideation**  | Gemini                | brainstorm & plan         |
| ⚙️ **Execution** | Claude                | agents run & file updates |
| 🔍 **Critique**  | Codex / Brutal Critic | analyseer & verbeter      |
| 📚 **Sync**      | Session Closer        | samenvatten & committen   |

Elke dag eindigt met:

* Geüpdatete contextbestanden
* Commit naar GitHub
* Verse start voor morgen

---

## 🪄 KEY TAKEAWAYS

* 📁 **Agents = markdown files** in `/agents/`
* 🔄 **Context-sync:** Claude ↔ Gemini ↔ Codex
* 🧩 **Session Closer** = automatische project-manager
* 💾 **Git commits** = geheugen + documentatie
* 🧠 **Brutal Critic** = AI-mentor die je roost en verbetert
* ⚙️ **Alles lokaal, alles versioned**

---

## 🪶 TL;DR — META-PROOF IN ONE SENTENCE

> Every project is alive:
> Claude manages, Gemini remembers, Codex critiques,
> and your “session-closer” commits it all —
> turning your ideas into code-versioned intelligence.

---

Wil je dat ik een **`session-closer.sh`** voor je maak
die dit automatisch doet (samenvatten, context-syncen, committen, en desnoods je “critic agent” triggert)?
