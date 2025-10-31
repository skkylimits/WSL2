# Lokale Testing met Caching

Dit document legt uit hoe je **supersnel** lokaal kan testen met gecachte packages, zodat je niet 4 minuten hoeft te wachten per test.

## Snelle Start

### Optie 1: Docker met BuildKit (SNELSTE)

```bash
# Eerste keer (duurt ~4 minuten)
chmod +x test-local.sh
./test-local.sh

# Tweede keer en daarna (duurt ~10 seconden!)
./test-local.sh
```

### Optie 2: act (GitHub Actions lokaal)

```bash
# Quick test (alleen nieuwe packages)
chmod +x test-with-act.sh
./test-with-act.sh quick

# Full test (complete setup)
./test-with-act.sh full
```

## De Magie van Caching

### Docker BuildKit Caching

De `Dockerfile` gebruikt **multi-stage builds** met **BuildKit cache mounts**:

```dockerfile
# Deze mount zorgt dat APT packages PERSISTENT blijven!
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get install -y proxychains4
```

**Wat betekent dit?**
- Eerste build: Downloads alle packages (~4 min)
- Tweede build: Gebruikt cache (~10 sec!)
- Je kan gewoon nieuwe packages toevoegen zonder alles opnieuw te downloaden

### GitHub Actions Caching

De `.github/workflows/test.yml` gebruikt `actions/cache`:

```yaml
- name: Cache APT packages
  uses: actions/cache@v4
  with:
    path: /var/cache/apt/archives/*.deb
    key: apt-cache-${{ runner.os }}-${{ hashFiles('src/run.sh') }}
```

Dit cached automatisch in GitHub Actions en werkt ook lokaal met `act`!

## Workflows

### 1. Nieuwe APT Package Toevoegen (Quick Iteration)

**Doel:** Je wilt proxychains4 toevoegen en snel testen

```bash
# 1. Edit Dockerfile regel ~30
vim Dockerfile

# Voeg toe:
# proxychains4 \

# 2. Quick test (duurt ~10 seconden dankzij cache!)
./test-local.sh apt-packages quick

# 3. Verify in container
docker run -it wsl2-setup:apt-cache bash
proxychains4 --version
```

**Waarom is dit snel?**
- Alle andere layers zijn gecached
- Alleen de `apt-packages` stage wordt opnieuw gebuild
- APT cache is persistent (downloads worden hergebruikt)

### 2. Script Aanpassingen Testen

**Doel:** Je hebt `src/run.sh` aangepast en wilt het testen

```bash
# Option A: Docker (snelste voor iteraties)
./test-local.sh

# Option B: act (test de GitHub Actions workflow)
./test-with-act.sh full
```

### 3. CI/CD Pipeline Testen voor Push

**Doel:** Je wilt zeker weten dat het in CI werkt voordat je pusht

```bash
# Test de volledige workflow lokaal
./test-with-act.sh full

# Als deze slaagt, is je push safe!
git add .
git commit -m "Added proxychains4"
git push
```

## Dockerfile Stages

De Dockerfile heeft verschillende stages voor maximale flexibiliteit:

| Stage | Beschrijving | Build tijd (cached) |
|-------|--------------|---------------------|
| `apt-packages` | Alleen APT packages | ~10 sec |
| `docker-install` | + Docker | ~15 sec |
| `shell-config` | + .bashrc configs | ~20 sec |
| `pyenv-install` | + pyenv | ~25 sec |
| `python-install` | + Python 3.12.6 | ~30 sec |
| `node-install` | + nvm & Node LTS | ~40 sec |
| `pnpm-install` | + pnpm | ~45 sec |
| `final` | Complete setup | ~50 sec |

### Stage-Specific Testing

```bash
# Test alleen tot een specifieke stage
./test-local.sh apt-packages
./test-local.sh python-install
./test-local.sh final  # (default)
```

## act Configuratie

De `.actrc` file configureert act voor optimale performance:

```bash
# Bind cache volumes (persistent tussen runs)
--container-options "--mount type=volume,src=act-apt-cache,dst=/var/cache/apt"
--container-options "--mount type=volume,src=act-pyenv-cache,dst=/root/.pyenv"
```

### act Cache Beheren

```bash
# Bekijk cache volumes
docker volume ls | grep act-

# Verwijder cache (fresh start)
docker volume rm act-apt-cache act-pyenv-cache act-nvm-cache act-pnpm-cache

# Herstart met lege cache
./test-with-act.sh full
```

## GitHub Actions Jobs

### Job: `test-setup` (Full Test)

Test de complete installatie met alle caching:
- APT packages cache
- pyenv cache
- nvm/Node cache
- pnpm cache

**Gebruik:** Voor complete end-to-end testing

### Job: `quick-test` (Fast Iteration)

Test alleen nieuwe APT packages met cache restore:
- Restore APT cache
- Install nieuwe package
- Verify

**Gebruik:** Voor snelle package tests (zoals proxychains4)

## Troubleshooting

### Build duurt nog steeds lang

```bash
# Check of BuildKit enabled is
docker buildx version

# Enable BuildKit expliciet
export DOCKER_BUILDKIT=1
./test-local.sh
```

### act werkt niet met cache

```bash
# Verify volumes
docker volume ls | grep act-

# Manually create volumes
docker volume create act-apt-cache
docker volume create act-pyenv-cache

# Retry
./test-with-act.sh quick
```

### "Out of space" errors

```bash
# Cleanup old builds
docker system prune -a --volumes

# Rebuild met cache
./test-local.sh
```

## Performance Comparison

| Methode | Eerste Run | Tweede Run | Nieuwe Package |
|---------|------------|------------|----------------|
| Zonder cache | 4-5 min | 4-5 min | 4-5 min |
| Docker BuildKit | 4-5 min | ~50 sec | ~10 sec |
| act met cache | 3-4 min | ~2 min | ~30 sec |
| Quick mode | N/A | N/A | ~10 sec |

## Best Practices

1. **Eerste keer:** Run `./test-local.sh` om cache op te bouwen
2. **Itereren:** Gebruik `./test-local.sh apt-packages quick` voor nieuwe packages
3. **Voor push:** Run `./test-with-act.sh full` om CI te simuleren
4. **Weekly:** Rebuild zonder cache voor fresh test

## Voorbeelden

### Voorbeeld 1: proxychains4 toevoegen

```bash
# 1. Edit Dockerfile
sed -i '30 a\    proxychains4 \\' Dockerfile

# 2. Quick test
./test-local.sh apt-packages quick

# 3. Verify
docker run -it --rm wsl2-setup:apt-cache proxychains4 --version

# 4. Test in CI
./test-with-act.sh quick

# 5. Push
git add Dockerfile
git commit -m "Added proxychains4"
git push
```

### Voorbeeld 2: Script aanpassing

```bash
# 1. Edit src/run.sh
vim src/run.sh

# 2. Full local test
./test-local.sh

# 3. CI test
./test-with-act.sh full

# 4. Push
git add src/run.sh
git commit -m "Updated installation script"
git push
```

## Tips

- Cache blijft bestaan tot je `docker builder prune` runt
- act cache volumes zijn persistent tot je ze verwijdert
- Gebruik `quick` mode voor 90% van je iteraties
- Run `full` mode alleen voor final verification
- BuildKit cache is intelligenter dan layer caching alleen

## Commando Overzicht

```bash
# Docker tests
./test-local.sh                    # Full test met cache
./test-local.sh apt-packages quick # Quick APT test
./test-local.sh python-install     # Test tot Python stage

# act tests
./test-with-act.sh quick  # Quick package test
./test-with-act.sh full   # Full CI simulation
./test-with-act.sh list   # List all jobs

# Cache management
docker builder prune      # Clear Docker build cache
docker volume ls         # List cache volumes
docker system df         # Check disk usage
```
