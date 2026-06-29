# Profili PC — Configurazione Pi Multi-Macchina

Sincronizza la configurazione Pi tra più PC, ognuno con il suo profilo
hardware/software riconoscibile automaticamente.

## Come funziona

1. **Ogni PC ha il suo profilo** in `~/progetti/profili/<hostname>/`
2. **La skill `profilo-pc` di Pi** lo riconosce automaticamente all'avvio
3. **Git sincronizza tutto** tra i vari PC
4. **Dal prompt di Pi**: "su che PC sono", "mostra profilo", "crea profilo"

## Setup iniziale

### 1. Crea la repo su GitHub (o altro git host)

```bash
# Crea una repo privata su github, poi:
cd ~/progetti/profili
git init
git add -A
git commit -m "init: struttura profili PC"
git remote add origin https://github.com/<TUO_USER>/profili-pc.git
git branch -M main
git push -u origin main
```

### 2. Installa la skill globalmente in Pi

```bash
mkdir -p ~/.pi/agent/skills
cp -r ~/progetti/profili/skills/profilo-pc ~/.pi/agent/skills/
```

Poi apri Pi e prova:
```
su che PC sono
```

### 3. Su ogni altro PC

```bash
# Clona il repo
git clone https://github.com/<TUO_USER>/profili-pc.git ~/progetti/profili

# Oppure usa il bootstrap automatico
bash ~/progetti/profili/bootstrap-pi.sh
```

Il bootstrap:
- Installa Pi (se non presente)
- Clona/sincronizza il repo
- Installa la skill `profilo-pc`
- Crea il profilo HW del PC corrente

## Workflow giornaliero

### All'avvio di Pi

Prima di iniziare, Pi riconosce automaticamente il PC in uso.
Se vuoi aggiornare/sincronizzare i profili:

```
# In Pi:
sync profili
```

Oppure manualmente:

```bash
cd ~/progetti/profili
git pull --rebase
```

### Dopo aver modificato un profilo o aggiunto fix

```
# In Pi:
aggiorna profilo
sync profili
```

Oppure:

```bash
cd ~/progetti/profili
git add -A
git commit -m "k10: aggiornamento dopo fix freeze"
git push
```

### Su un altro PC, ricevi gli aggiornamenti

```
# In Pi:
sync profili
```

Oppure:

```bash
cd ~/progetti/profili
git pull --rebase
```

## Comandi Pi disponibili

| Frase | Cosa fa |
|---|---|
| `su che PC sono` | Mostra identità PC + profilo corrente |
| `mostra profilo` | Mostra PROFILO.md completo |
| `sono su k10` | Carica profilo di un PC specifico |
| `crea profilo` | Rileva hardware e crea nuovo profilo |
| `aggiorna profilo` | Rileva hardware, aggiorna PROFILO.md |
| `sync profili` | Git pull + push dei profili |
| `lista PC` | Elenca tutti i profili disponibili |
| `configura questo PC` | Bootstrap completo su PC nuovo |

## Struttura directory

```
profili/
├── PROJECT.md              ← regole progetto (caricate da Pi)
├── README.md               ← questo file
├── bootstrap-pi.sh         ← installa Pi + profilo su PC nuovo
├── nuovo_profilo.sh        ← crea profilo HW/SW
├── skills/
│   └── profilo-pc/
│       └── SKILL.md        ← Pi skill per auto-riconoscimento
├── k10/                    ← profilo PC "k10"
│   ├── PROFILO.md
│   └── ripristino_monitor.sh
└── <hostname2>/            ← profilo altro PC
    ├── PROFILO.md
    └── ripristino_*.sh
```

## Esempio di sessione

```
Utente:   su che PC sono
Pi:       ✅ Sei su k10 — Lenovo ThinkCentre M93p
          CPU: Intel Core i3-4130T, 11 GB RAM, 12 monitor
          OS: Ubuntu 24.10, Kernel 6.11.0-26

Utente:   aggiorna profilo
Pi:       Rilevato nuovo kernel 6.12.0-12. Vuoi aggiornare? (s/N)
Utente:   s
Pi:       ✅ PROFILO.md aggiornato per k10

Utente:   lista PC
Pi:       Profili disponibili:
          • k10   — Lenovo ThinkCentre M93p (Desktop) — Ubuntu 24.10
          • xps15 — Dell XPS 15 9570 (Laptop) — Ubuntu 24.04
          • server — HP ProLiant DL380 (Server) — Ubuntu 22.04 LTS
```
