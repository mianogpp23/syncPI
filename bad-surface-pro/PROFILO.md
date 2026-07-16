# Profilo PC: bad

> Identificatore univoco: `bad-surface-pro` — (cartella profilo)

## Identità
| Campo | Valore |
|---|---|
| **Machine ID** | `5a5c98f5041a477cb9984a4d7059df06` |
| **Profile ID** | bad-surface-pro |
| **Modello** | Microsoft Corporation Surface Pro |
| **Chassis** | Laptop/Portatile |
| **Hostname** | bad |

---

## Sistema Operativo

| Campo | Valore |
|---|---|
| **OS** | Kali GNU/Linux Rolling 2025.2 |
| **Kernel** | 6.15.1-surface-2 (patch Microsoft Surface) |
| **Arch** | amd64 |
| **Desktop** | XFCE su X11 |
| **Shell** | bash |
| **Pacchetti** | 4136 installati |
| **Uptime** | 1h 51m (al rilevamento) |

---

## Hardware

### CPU
- **Intel Core i5-7300U** @ 2.60 GHz (boost 3.5 GHz)
- 2 core / 4 thread
- Architettura: x86_64
- Virtualization: VT-x

### GPU
- **Intel HD Graphics 620** (integrata)
- Driver: i915 (open source)

### RAM
- Totale: **7.7 GB**
- Usata: 4.1 GB (al rilevamento)
- Swap: nessuno configurato

### Storage

| Dispositivo | Dimensione | Tipo | Mount | Stato |
|---|---|---|---|---|
| `nvme0n1` | 238.5 GB | NVMe SSD | — | Disco fisico principale |
| `nvme0n1p1` | 100 MB | vfat | `/boot/efi` | EFI System Partition |
| `nvme0n1p2` | 16 MB | — | — | Microsoft Reserved |
| `nvme0n1p3` | 132.8 GB | BitLocker | — | ❗ Windows (criptato) |
| `nvme0n1p4` | 935 MB | ntfs | — | Recovery/Windows |
| `nvme0n1p5` | 104.6 GB | ext4 | `/` | **Kali Linux — 90% pieno (88G/103G)** |
| `sdb1` | 116.5 GB | ntfs | `/media/k10/6282BC084FD01815` | Disco esterno USB |

### Rete
- **Wi-Fi:** Marvell 88W8897 [AVASTAR] 802.11ac (wlx... — interfaccia `mlan0`)
- **Ethernet:** nessuna (solo Wi-Fi)
- **IP locale:** 10.179.194.112/24

### Audio
- Intel Sunrise Point-LP HD Audio

### Batteria / Alimentazione
- Batteria: **51%** ( Charging / in carica )
- Alimentatore connesso: ✅

---

## Configurazione Pi

| Campo | Valore |
|---|---|
| **Pi versione** | 0.80.7 |
| **Desktop** | XFCE |
| **Tema attuale** | Kali-Light + Flat-Remix-Blue-Light |
| **Skill custom** | credem-forensics, farmacia-ai, linux-sysadmin, profilo-pc |

### Problemi noti

1. **❌ Disco root al 90%** — 11 GB liberi su 103 GB. Considerare cleanup o espansione partizione.
2. **⚠️ Nessuno swap configurato** — Con 8 GB RAM e uso intensivo, rischio OOM killer. Consigliato almeno 4 GB swap su file.
3. **⚠️ Dual-boot con Windows BitLocker** — Partizione Windows criptata (nvme0n1p3). Accesso solo con chiave BitLocker.

### Storico interventi

| Data | Intervento |
|---|---|
| 16/07/2025 | Creazione profilo + tema Kali-Light |
