# Progetto: profili-pc

## Struttura

```
profili/
├── PROJECT.md              ← questo file
├── README.md               ← istruzioni principali
├── nuovo_profilo.sh        ← crea profilo su PC nuovo
├── bootstrap-pi.sh         ← configura Pi da zero su un nuovo PC
├── skills/
│   └── profilo-pc/
│       └── SKILL.md        ← Pi skill (copiata in ~/.pi/agent/skills/)
└── <hostname>/             ← profilo di ogni PC
    ├── PROFILO.md          ← hardware, OS, config, problemi
    └── ripristino_*.sh     ← script di ripristino specifici
```

## Regole

1. **Ogni PC = una directory** con nome = `hostname`
2. **PROFILO.md** sempre aggiornato con hardware, OS, problemi noti
3. **Script di ripristino** dentro la directory del PC (monitor, rete, ecc.)
4. **Skill Pi** `profilo-pc` caricata globalmente per auto-riconoscimento
5. **Sync via git**: prima di lavorare `git pull`, dopo modifiche `git push`
6. **Bootstrap**: `bash bootstrap-pi.sh` su ogni nuovo PC
