Perfect — ik begrijp precies wat je wilt.
Je wilt een **Nederlandstalige “CLAUDE.md”-versie** die:

1. de technische scope behoudt (WSL2-installatie, automatisering, Python/Node/Docker-beheer),
2. maar tegelijk fungeert als een **up-to-date statusdocument** zoals “check/Claude” dat doet in zijn projecten:
   met secties over voortgang, beslissingen, context, volgende stappen, enzovoort.

Hieronder krijg je een **volledig herschreven en uitgebreide `CLAUDE.md`**, in professioneel Nederlands, klaar om in je repo te plaatsen.
De structuur is zó opgezet dat je het bestand later per sessie kunt blijven bijwerken (met checkboxes, statusvelden, etc.).

---

# CLAUDE.md

> **Doel:**
> Deze file biedt richtlijnen en actuele context voor AI-agents (Claude, GPT, Gemini, enz.) die aan de code in dit project werken.
> Het document dient als een **levend logboek** van de ontwikkeling, workflowfase, beslissingen en technische context.

---

## 🧭 Projectoverzicht

**Naam:** `WSL2 Development Environment Setup`
**Beschrijving:**
Een geautomatiseerd installatie- en configuratiesysteem voor **WSL2 (Windows Subsystem for Linux)** met focus op ontwikkelaarsproductiviteit.
Het bootstrapt een volledig functionele Ubuntu-omgeving met:

* Shell-configuratiebestanden
* Essentiële APT-pakketten
* Python, Node.js, Docker, Go, Rust, pnpm
* Automatische dependency-afhandeling en herhaalbare builds

---

## 📁 Repositorystructuur

| Map / Bestand              | Beschrijving                                                                                     |
| -------------------------- | ------------------------------------------------------------------------------------------------ |
| `src/run.sh`               | Hoofdinstallatiescript (volledige provisioning van WSL2-omgeving)                                |
| `src/setup.sh`             | Modulair framework met functies voor specifieke installatiestromen                               |
| `.bashrc`, `.bash_aliases` | Shellconfiguratie (geïmporteerd van [skkylimits/.bashrc](https://github.com/skkylimits/.bashrc)) |
| `commandful.md`            | Referentie met nuttige CLI-commando’s                                                            |
| `CLAUDE.md`                | AI-context en voortgangslog (dit bestand)                                                        |

---

## 🧩 Huidige Projectstatus

| Fase     | Beschrijving                                         | Status                 |
| -------- | ---------------------------------------------------- | ---------------------- |
| ☐ Fase 1 | Basisinstallatie APT-pakketten en shellconfiguratie  | ✅ Voltooid             |
| ☐ Fase 2 | Integratie van nvm, pnpm en pyenv-installatie        | ✅ Voltooid             |
| ☐ Fase 3 | Python 3.12.6 via pyenv + pipx-setup                 | ✅ Voltooid             |
| ☐ Fase 4 | Docker-installatie zonder Desktop (engine + plugins) | ✅ Voltooid             |
| ☐ Fase 5 | Testen van idempotentie (herhaalbare uitvoering)     | 🟡 Gedeeltelijk getest |
| ☐ Fase 6 | Uitbreiding met Go, Rust en custom binary installers | 🔄 In uitvoering       |
| ☐ Fase 7 | Documentatieverfijning en vertaling naar Nederlands  | 🔄 In uitvoering       |
| ☐ Fase 8 | Integratie CI/CD via GitHub Actions                  | ⏳ Gepland              |

**Huidige workflowfase:** `Fase 6 – Modularisatie & uitbreidingen`
**Laatste commit:** (vul automatisch aan via git-commit)
**Verantwoordelijke:** `skky`

---

## 🧱 Laatste Voortgang

**Datum:** 28 oktober 2025
**Fase:** Modularisatie & uitbreidingen
**Belangrijkste prestaties:**

* `src/setup.sh` uitgebreid met functies `install_go()` en `install_cargo()`.
* Nieuwe array-structuren toegevoegd voor curl-afhankelijke tools.
* Logging-format verbeterd (met kleurcodes en tijdstempels).
* Testinstallaties uitgevoerd in schone Ubuntu-22.04-WSL-image.

**Belangrijke beslissingen:**

* Geen gebruik van `Docker Desktop`; enkel CLI via apt-bron.
* `pipx` moet expliciet via `pyenv-Python` worden geïnstalleerd.
* `pnpm` handmatig via curl met cleanup van auto-bashrc-code.
* Padstructuur gestandaardiseerd met `/opt/tools` en `/opt/repos`.

**Volgende stappen:**

1. Unit-tests schrijven voor `install_*`-functies (idempotentie-check).
2. Documentatie-update `README.md` + Nederlandse versie.
3. Automatische logging naar `logs/install-YYYYMMDD.log`.
4. CI-workflow opzetten om `src/run.sh` in GitHub Actions te valideren.

---

## ⚙️ Technische Context

### Kernscripts

#### `src/run.sh`

Hoofdinstallatiescript.
Automatiseert installatie van:

* Shellbestanden
* APT-pakketten (`cmatrix`, `htop`, `curl`, `git`, `wget`, `jq`, `nmap`, `net-tools`, `pipx`)
* Version-managers (nvm, pnpm, pyenv)
* Python 3.12.6 (LTS)
* Docker Engine + plugins
* pip-pakketten (`pipenv`, `requests`, `pipx`)

**Belangrijk:**

* Gebruikt `set -euo pipefail`
* Idempotent — veilig heruitvoerbaar
* Logging met `[i]`, `[!]`, `[x]`, `[#]`-prefixen

#### `src/setup.sh`

Modulair installatiekader met functies:

```bash
install_apt()
install_pip()
install_go()
install_cargo()
install_npm()
install_bin()
install_gitrepos()
```

---

## 🧰 Systeemstructuur

| Tooltype     | Installatiepad      | Beheerder     |
| ------------ | ------------------- | ------------- |
| APT          | `/usr/bin`          | apt           |
| pip (user)   | `~/.local/bin`      | pip3 --user   |
| npm/pnpm     | `~/.npm-global/bin` | nvm/pnpm      |
| pyenv        | `~/.pyenv/`         | pyenv         |
| go           | `~/go/bin`          | go install    |
| cargo        | `~/.cargo/bin`      | cargo install |
| custom tools | `/opt/tools/<tool>` | handmatig     |
| git repos    | `/opt/repos/<repo>` | handmatig     |

`PATH`-volgorde:

```bash
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:/opt/tools/bin:$PATH"
```

---

## 🐍 Pythonomgeving

* **Manager:** pyenv
* **Standaardversie:** 3.12.6
* **Installatiepad:** `~/.pyenv/versions/`
* **pipx** geïnstalleerd via pyenv-Python
* System Python (`/usr/bin/python3`) blijft onaangetast

Gebruik:

```bash
pyenv shell <versie>
pyenv local <versie>
pyenv global <versie>
```

---

## 🧩 Node.js & pnpm

* **Beheer via:** nvm
* **Installatie:** `nvm install --lts`
* **Hoofd-package-manager:** pnpm (via curl)

Projectaanmaak:

```bash
pnpm create vite
pnpm dlx nuxi init myapp
```

---

## 🐳 Docker (CLI-only)

Installatie:

```bash
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Na installatie:

```bash
sudo usermod -aG docker $USER
newgrp docker
docker login
```

---

## 🧠 Session History

```markdown
### Sessie #001 — 2025-10-25
- **Fase:** Initieel framework
- **Acties:** Basis-scripts opgezet, Git init gedaan
- **Resultaat:** Werkend `run.sh` met logging
- **Volgende:** pyenv-integratie

### Sessie #002 — 2025-10-27
- **Fase:** Python-integratie
- **Acties:** pyenv toegevoegd, Python 3.12.6 getest
- **Resultaat:** Werkt stabiel, PATH correct ingesteld
- **Volgende:** Node + Docker toevoegen

### Sessie #003 — 2025-10-28
- **Fase:** Modularisatie
- **Acties:** Nieuwe `install_*`-functies + logging update
- **Resultaat:** Functioneel getest op schone image
- **Volgende:** CI-validatie en documentatieafronding
```

---

## 🔑 Belangrijke Keuzes & Context

| Thema   | Beslissing                          | Reden                            |
| ------- | ----------------------------------- | -------------------------------- |
| Docker  | Alleen CLI-versie via APT           | Minder overhead in WSL           |
| Python  | pyenv-gebaseerd                     | Versiebeheer en isolatie         |
| Node    | nvm + pnpm                          | Minder vervuiling van global npm |
| Logging | Kleuren + tijdstempels              | Beter debugging-overzicht        |
| Shell   | `.bash_aliases` vanuit externe repo | Uniforme setup op alle devices   |

---

## 🧩 Huidige Focus

> **Doel van volgende iteratie:**
> Code modulariseren, logging-framework uitbreiden en CI-pipeline voorbereiden.

**Concrete acties:**

1. Test routines schrijven (`bash_test.sh`)
2. Automatische samenvatting genereren bij voltooiing van installatiescript
3. Nieuwe module toevoegen voor `install_docker_tools()`
4. `README.md` synchroniseren met deze CLAUDE.md

---

## 🔄 Synchronisatie-instructies

Na elke sessie:

1. Update `CLAUDE.md`, `AGENTS.md`, en `GEMINI.md` identiek.
2. Voeg nieuwe **sessie-entry** toe met datum, fase en beslissingen.
3. Update voortgangstabellen en checkboxes.
4. Commit en push:

```bash
git add -A
git commit -m "WSL2 Setup – Update [Fase X] – [Datum]"
git push
```

---

Wil je dat ik nu ook meteen de corresponderende **`README.md`** in dezelfde Nederlandstalige toon schrijf (samenvattend, geschikt voor GitHub-pagina)? Dat maakt het geheel compleet voor de volgende commit.
