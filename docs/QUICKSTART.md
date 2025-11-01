# Quick Start: Snelle Iteraties met Caching

## Het Probleem

Je wilt proxychains4 toevoegen aan je APT packages, maar elke CI run duurt 4 minuten omdat alles opnieuw gedownload wordt. 😤

## De Oplossing

Met **Docker BuildKit caching** en **act** test je lokaal in ~10 seconden! 🚀

## Setup (1x doen)

```bash
# 1. Eerste build (duurt ~4 min, eenmalig)
chmod +x test-local.sh test-with-act.sh
./test-local.sh
```

**Dat is het!** Cache is nu klaar voor snelle iteraties.

## Snelle Workflow: Nieuwe APT Package Toevoegen

### Stap 1: Edit Dockerfile

```bash
vim Dockerfile
```

Voeg je package toe op regel ~30:

```dockerfile
# Voeg hier nieuwe APT packages toe:
proxychains4 \
ncat \
# whatever-else \
```

### Stap 2: Quick Test (10 seconden!)

```bash
./test-local.sh apt-packages quick
```

### Stap 3: Verify

```bash
docker run -it --rm wsl2-setup:apt-cache bash
proxychains4 --version
```

### Stap 4: CI Test (lokaal)

```bash
./test-with-act.sh quick
```

### Stap 5: Push

```bash
git add Dockerfile
git commit -m "Added proxychains4"
git push
```

Done! 🎉

## Waarom is dit Snel?

### Zonder Cache
```
❌ Build 1: 4 minuten
❌ Build 2: 4 minuten
❌ Build 3: 4 minuten
😫 Totaal: 12 minuten
```

### Met Cache
```
✅ Build 1: 4 minuten (cache opbouwen)
✅ Build 2: 10 seconden (cache gebruiken!)
✅ Build 3: 10 seconden
😎 Totaal: ~4.5 minuten
```

**Je bespaart ~7.5 minuten!** En bij meer iteraties nog meer.

## Commando's

| Commando | Wat doet het | Duur |
|----------|--------------|------|
| `./test-local.sh` | Full test | ~50 sec (cached) |
| `./test-local.sh apt-packages quick` | Alleen APT packages | ~10 sec |
| `./test-with-act.sh quick` | Quick CI test | ~30 sec |
| `./test-with-act.sh full` | Full CI test | ~2 min |

## Tips

1. **Gebruik `quick` mode** voor het toevoegen van packages
2. **Test lokaal eerst** voordat je pusht
3. **Cache blijft bestaan** tot je `docker builder prune` runt
4. **90% sneller** door caching 🚀

## Volledige Docs

Zie `TESTING.md` voor complete uitleg en advanced workflows.

## Hulp Nodig?

```bash
./test-local.sh --help      # (TODO: help toevoegen)
./test-with-act.sh --help   # (TODO: help toevoegen)
```

Of bekijk `TESTING.md` voor troubleshooting.
