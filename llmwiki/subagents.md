# Subagents in Pi

I **subagents** sono un'estensione di Pi che permette di delegare compiti ad agenti specializzati con contesto isolato.

## Come funziona

Ogni subagent viene eseguito come **processo Pi separato** (in modalità JSON), con un proprio system prompt personalizzato. Questo garantisce isolamento del contesto e permette di specializzare ogni agente per un compito specifico.

## Dove si definiscono gli agent

| Percorso | Scopo |
|----------|-------|
| `~/.pi/agent/agents/` | Agenti globali (disponibili ovunque) |
| `.pi/agents/` (nel progetto) | Agenti locali al progetto |

Ogni agente è un file (es. `esperto-bash.md`) contenente il suo system prompt.

## Modalità d'uso

### 1. Single (singolo agente)

```
subagent(agent: "nome-agente", task: "descrizione del compito")
```

### 2. Parallel (più agenti in contemporanea)

```
subagent(tasks: [
  { agent: "agente1", task: "compito 1" },
  { agent: "agente2", task: "compito 2" }
])
```

Massimo 8 task paralleli, 4 in contemporanea.

### 3. Chain (catena sequenziale)

```
subagent(chain: [
  { agent: "agente1", task: "primo compito" },
  { agent: "agente2", task: "revisione: {previous}" },
  { agent: "agente3", task: "finalizza: {previous}" }
])
```

Il placeholder `{previous}` viene sostituito con l'output dell'agente precedente.

## Esempio di agente personalizzato

Crea `~/.pi/agent/agents/esperto-oscam.md`:

```markdown
Sei un esperto di OSCam per decoder Enigma2.
Conosci tutti i parametri di configurazione per server cardsharing,
CAID, reader NewCamd/CCcam, ICAM, ecc.
Rispondi in italiano, sii sintetico e pratico.
```

Poi puoi chiamare:
```
subagent(agent: "esperto-oscam", task: "Configura un reader newcamd per Sky DE")
```

## Vantaggi

- **Isolamento**: contesto pulito, non si mescolano informazioni
- **Specializzazione**: ogni agente ha un ruolo preciso
- **Parallelismo**: più agenti lavorano contemporaneamente
- **Catene**: pipeline di lavoro automatiche
- **Riutilizzo**: gli agenti possono essere condivisi tra progetti
