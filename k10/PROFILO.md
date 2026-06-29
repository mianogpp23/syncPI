# Profilo PC: k10

## Identità
| Campo | Valore |
|---|---|
| **Machine ID** | `40d1f6d141d24e82a92c4ab243013dd2` |
| **Modello** | Lenovo ThinkCentre M93p (10A8S0LQ00) |
| **Chassis** | Desktop |
| **Hostname** | k10 |

---

## Sistema Operativo

| Campo | Valore |
|---|---|
| **OS** | Ubuntu 24.10 (Oracular Oriole) |
| **Kernel** | 6.11.0-26-generic |
| **Arch** | amd64 |
| **Desktop** | KDE Plasma 6.1.5 su Wayland |
| **Shell** | /bin/bash |
| **Pacchetti** | 4.675 installati |

---

## Hardware

### CPU
- **Intel Core i3-4130T** @ 2.90 GHz
- 4 core / 4 thread
- 3 MB cache

### Video

#### GPU
- **2× AMD FirePro W600** (Cape Verde PRO)
  - GPU1: 6× mini-DP
  - GPU2: 6× mini-DP
- **Driver:** `radeon` (open source)
- Configurazione: **12 monitor**, risoluzione totale **8555×3221**

#### Monitor (12 display)

| # | Output | Risoluzione | Posizione (X+Y) | Rotazione | Dimensione fisica |
|---|---|---|---|---|---|
| 1 | DP-11 | 1920×1200 | 0+0 | normale | 518×324 mm |
| 2 | DP-1 | 947×1684 | 151+1200 | left | 443×249 mm |
| 3 | DP-4 | 1050×1680 | 1099+1200 | right | 434×270 mm |
| 4 | DP-5 | 1366×768 | 1920+432 | normale | 410×230 mm |
| 5 | DP-8 | 1920×1080 | 3286+120 | normale | 160×90 mm |
| 6 | DP-6 | 1920×1200 | 3286+1200 | normale | 1860×1047 mm |
| 7 | DP-7 | 1366×768 | 5206+432 | normale | 410×230 mm |
| 8 | DP-9 | 1105×1768 | 5206+1200 | right | 473×296 mm |
| 9 | DP-2 | 1105×1768 | 6312+1200 | left | 473×296 mm |
| 10 | DP-3 | 1680×1050 | 6572+150 | normale | 433×271 mm |
| 11 | DP-10 | 1137×2021 | 7418+1200 | right | 477×268 mm |
| 12 | DP-12 | 1137×2021 | 2149+1200 | right | 521×293 mm |

#### Schema posizioni (vista dall'alto)
```
┌───────┬──────────┬──────────┬───────┬───────┬──────────┐
│ DP-11 │   DP-1   │  DP-4    │ DP-5  │ DP-8  │  DP-7    │
│1920×12│ 947×1684 │1050×1680 │1366×76│1920×10│ 1366×768 │
│  00   │  (left)  │ (right)  │   8   │  80   │          │
├───────┴──────────┴──────────┴───────┴───────┴──────────┤
│                       DP-6                             │
│                    1920×1200                            │
├──────────┬──────────┬──────────┬──────────┬────────────┤
│  DP-9    │  DP-2    │  DP-3    │  DP-10   │   DP-12    │
│1105×1768 │1105×1768 │1680×1050 │1137×2021 │ 1137×2021  │
│ (right)  │ (left)   │          │ (right)  │  (right)   │
└──────────┴──────────┴──────────┴──────────┴────────────┘
```

### RAM
- Totale: **11 GB**
- Tipo: DDR3 (presumibile)
- Slots: (da verificare con dmidecode)

### Storage

| Dispositivo | Dimensione | Modello | Tipo |
|---|---|---|---|
| `nvme0n1` | 119.2 GB | PSELN128GA87MC0 | **NVMe (OS)** — ❗ 96% pieno |
| `sda` | 69.2 GB | WDC WD740ADFD-00NLR5 | HDD 7.200 rpm |
| `sdb` | 1.8 TB | WDC WD20EARX-00PASB0 | HDD (passwordlist/media) |
| `sdc` | 480 MB | Flash Disk | USB |

### Rete
- **Ethernet:** Intel I217-LM (Gigabit)

### Audio
- Intel 8 Series/C220 HDA (onboard)
- 2× AMD/ATI HDMI Audio (FirePro W600)

---

## Accesso Remoto

| Servizio | Dettaglio |
|---|---|
| **RustDesk ID** | `1317205209` |
| **RustDesk Password** | `axios` |
| **RustDesk Server** | `rs-ny.rustdesk.com:21116` |

---

## Configurazione Pi

| Componente | Versione/Valore |
|---|---|
| **Pi core** | 0.79.10 |
| **Provider** | opencode |
| **Modello** | deepseek-v4-flash-free |
| **Tema** | dark |
| **Estensioni** | 12 pacchetti npm (pi-web-access, pi-goal, pi-plan-mode, pi-skill-creator, pi-subagents, pi-codex-goal, pi-mcp-adapter, pi-permission-system, pi-chrome-devtools, @pi-stef/catalog, @pi-stef/web, pi-rtk-opt) |
| **Knowledge base** | llmwiki (sostituisce Hermes) |
| **Skill custom** | credem-forensics, linux-sysadmin |
| **Progetti** | Credem, filetmp, profili, system-check |

---

## Problemi noti e fix applicati

### 1. ❌ Sistema freeze — RAM + Swap esauriti (22/06/2026)
- **Sintomo:** Sistema freezato, load > 16, swap 100%
- **Causa:** Kate (PID 48274) con file grande `realhuman_phill.txt` (684 MB) bloccava 5 GB RAM + baloo_file_extractor indicizzava disco esterno (1.8 TB)
- **Fix applicati:**
  - ✅ Kate killata (libere ~5 GB RAM)
  - ✅ Baloo sospeso e `/media/` escluso dall'indicizzazione (`~/.config/baloofilerc`)
  - ✅ swappiness 60 → **10** (script `ottimizza_sistema.sh`)
  - ✅ dirty_ratio 20% → **10%**
  - ✅ Servizi inutili disabilitati: **nessusd, mariadb, postgresql, firebird3.0**
- **Script fix:** `~/progetti/filetmp/ottimizza_sistema.sh`
- **Backup config KDE:** `/media/k10/PASSWORDLIST/ripristino waylandk10/`
  - `ripristino_monitor.sh` — reset 12 monitor
  - `ripristino_config.sh` — ripristino pannelli/tema/wallpaper

### 2. ❌ NVMe di sistema quasi pieno
- **Stato:** 111 GB / 119 GB usati (96%)
- **Rischio:** Swap da 8 GB + cache potrebbero saturare il disco
- **Da fare:** Liberare spazio su NVMe

### 3. ⚠️ LibreOffice xmlsec mismatch
- **Errore:** `xmlSecCheckVersionExt: invalid version` expected subminor=41, real=39
- **Impatto:** Conversioni DOCX→PDF funzionano comunque (warning non fatale)

### 4. ⚠️ sudo senza passwordless
- Questo PC non ha sudo NOPASSWD configurato
- Script con sudo vanno eseguiti da terminale manualmente

| Data | Intervento |
|---|---|
| 22/06/2026 | Aggiornamento Pi 0.79.7 → 0.79.10 + 10 estensioni |
| 22/06/2026 | Creazione `pi-bootstrap.sh` + `pi-config.md` per clonare configurazione |
| 22/06/2026 | Organizzazione wordlist PASSWORDLIST (433 GB → strutturato) |
| 22/06/2026 | Backup config KDE: `ripristino_monitor.sh` + `ripristino_config.sh` su disco esterno |
| 22/06/2026 | Fix freeze: kill Kate (5GB RAM), stop baloo su /media/, ottimizzazione sistema |
| 22/06/2026 | Disabilitati servizi inutili: nessusd, mariadb, postgresql, firebird3.0 |
| 22/06/2026 | Swappiness 60→10, dirty_ratio 20%→10% |
