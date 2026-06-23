---
name: profilo-pc
description: >
  Gestione profili PC multi-macchina per Pi. Attivare quando l'utente menziona profili PC,
  chiede "su che PC sono", "mostra profilo", "crea profilo", "aggiorna profilo",
  dice "sono su [nome PC]", o quando si vuole rilevare automaticamente il sistema corrente.
  Include bootstrap, sync git, e auto-riconoscimento hardware.
---

# Profilo PC Skill

Skill per gestire profili hardware/software di PC multipli, sincronizzati via git.
Ogni PC ha il suo profilo con specifiche complete, riconoscibile da Pi automaticamente.

---

## Directory profili

```
~/progetti/profili/           ← git repo principale
├── <hostname>/               ← profilo del PC (nome = hostname)
│   ├── PROFILO.md            ← hardware, OS, config, problemi, storico
│   └── ripristino_*.sh       ← script di ripristino specifici
├── nuovo_profilo.sh          ← crea profilo su PC nuovo
├── bootstrap-pi.sh           ← configura Pi da zero su nuovo PC
└── skills/profilo-pc/        ← questa skill
    └── SKILL.md
```

---

## Auto-riconoscimento

All'attivazione, Pi determina automaticamente il PC corrente:

1. Legge `hostname` (comando: `hostname`)
2. Cerca `~/progetti/profili/<hostname>/PROFILO.md`
3. Se trovato → carica il profilo nel contesto
4. Se non trovato → chiede se crearlo

Per sessioni cross-PC (es. stai lavorando su un PC ma parli di un altro):
- "sono su [nome PC]" → carica il profilo di quel PC dal disco

---

## Comandi vocali (dal prompt)

| Frase | Azione |
|---|---|
| "su che PC sono" | Mostra identità PC + profilo corrente |
| "mostra profilo" | Mostra PROFILO.md completo del PC corrente |
| "sono su [nome]" | Carica profilo di quel PC (es. "sono su k10") |
| "crea profilo" | Esegue `bash ~/progetti/profili/nuovo_profilo.sh` |
| "aggiorna profilo" | Rileva hardware attuale e aggiorna PROFILO.md |
| "sync profili" | `cd ~/progetti/profili && git pull && git push` |
| "lista PC" | Elenca tutti i profili disponibili in `~/progetti/profili/` |
| "configura questo PC" | Esegue `bash ~/progetti/profili/bootstrap-pi.sh` |

---

## Procedura di attivazione

### Se l'utente dice "sono su [PC]" o chiede del profilo corrente:

1. Determina `hostname` con `hostname`
2. Cerca `~/progetti/profili/<hostname>/PROFILO.md`
   - Se trovato: leggilo e conferma "✅ Sei su **<hostname>** — <modello PC>"
   - Se non trovato: "❌ Nessun profilo per questo PC. Vuoi crearne uno?"
3. Se l'utente dice "sono su [altro_nome]":
   - Cerca `~/progetti/profili/<altro_nome>/PROFILO.md`
   - Se trovato: caricalo e conferma
   - Se non: "❌ Profilo [altro_nome] non trovato"

### Se l'utente dice "crea profilo":

1. Esegui `bash ~/progetti/profili/nuovo_profilo.sh`
2. Leggi il nuovo PROFILO.md
3. Conferma: "✅ Profilo per <hostname> creato!"

### Se l'utente dice "aggiorna profilo":

1. Rileva hardware corrente (CPU, RAM, GPU, storage, kernel, OS)
2. Leggi il PROFILO.md esistente
3. Confronta e segnala differenze
4. Chiedi conferma prima di aggiornare
5. Aggiorna PROFILO.md con:
   - Nuovo kernel/OS se cambiato
   - Nuovo hardware se cambiato
   - Aggiungi riga in "Storico interventi"

### Se l'utente dice "sync profili":

1. `cd ~/progetti/profili`
2. `git status` per vedere se ci sono modifiche locali
3. Se modifiche: `git add -A && git commit -m "aggiornamento profilo <hostname>" && git push`
4. Poi: `git pull --rebase`
5. Conferma risultato

---

## Verifica

- "su che PC sono" → restituisce hostname e riepilogo hardware
- "mostra profilo" → mostra PROFILO.md completo
- La skill carica automaticamente il profilo all'attivazione
- Dopo bootstrap su PC nuovo, il profilo esiste e viene riconosciuto
