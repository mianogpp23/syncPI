#!/bin/bash
# ============================================================
# nuovo_profilo.sh
# Crea o rigenera un profilo per questo PC dentro ~/progetti/profili/
# Da eseguire su ogni PC dove viene sincronizzato il repo profili.
# ============================================================

set -e

HOST=$(hostname)
DIR="$HOME/progetti/profili/$HOST"

if [ -d "$DIR" ]; then
    echo "⚠️  Profilo '$HOST' esiste già in $DIR"
    echo "   Opzioni:"
    echo "   1) RIGENERA   — rm -rf e ricrea da capo"
    echo "   2) AGGIORNA   — mantieni storico, aggiorna hardware"
    echo "   3) ANNULLA    — esci"
    echo ""
    echo -n "Scelta (1/2/3) [3]: "
    read -r SCELTA
    case "$SCELTA" in
        1) rm -rf "$DIR" ;;
        2) AGGIORNA=true ;;
        *) echo "Annullato."; exit 0 ;;
    esac
fi

mkdir -p "$DIR"

# --- RACCOLTA DATI ---

# OS
if command -v lsb_release &>/dev/null; then
    OS_NAME=$(lsb_release -ds 2>/dev/null)
elif [ -f /etc/os-release ]; then
    OS_NAME=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
else
    OS_NAME=$(uname -s)
fi
OS_VERSION=$(grep VERSION_ID /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' || echo "N/A")
KERNEL=$(uname -r)
ARCH=$(dpkg --print-architecture 2>/dev/null || uname -m)
SHELL=$(basename "$SHELL" 2>/dev/null || echo "N/A")
UPTIME=$(uptime -p 2>/dev/null | sed 's/up //' || echo "N/A")
PACKAGE_COUNT=$(dpkg -l 2>/dev/null | wc -l || rpm -qa 2>/dev/null | wc -l || echo "N/A")

# Hardware
if [ -d /sys/devices/virtual/dmi/id ]; then
    MODEL=$(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null || echo "N/A")
    VENDOR=$(cat /sys/devices/virtual/dmi/id/sys_vendor 2>/dev/null || echo "N/A")
    CHASSIS=$(cat /sys/devices/virtual/dmi/id/chassis_type 2>/dev/null || echo "N/A")
    case "$CHASSIS" in
        3|4|5|6|7) CHASSIS_NAME="Desktop" ;;
        8|9|10|11|12|14) CHASSIS_NAME="Laptop/Portatile" ;;
        17|19|20|21|22|23) CHASSIS_NAME="Server/Rack" ;;
        30|31|32) CHASSIS_NAME="Tablet/Convertible" ;;
        *) CHASSIS_NAME="N/A ($CHASSIS)" ;;
    esac
else
    MODEL="N/A (non-DMI)"
    VENDOR="N/A"
    CHASSIS_NAME="N/A"
fi
MACHINE_ID=$(cat /etc/machine-id 2>/dev/null || echo "N/A")
CPU=$(lscpu 2>/dev/null | grep "Model name" | head -1 | cut -d: -f2 | xargs || echo "N/A")
CPU_CORES=$(nproc 2>/dev/null || echo "N/A")
CPU_ARCH=$(lscpu 2>/dev/null | grep "Architecture" | head -1 | cut -d: -f2 | xargs || echo "N/A")
CPU_MAX_MHZ=$(lscpu 2>/dev/null | grep "CPU max MHz" | head -1 | cut -d: -f2 | xargs || echo "N/A")

# RAM
RAM_TOTAL=$(free -h 2>/dev/null | awk '/Mem:/{print $2}' || echo "N/A")
RAM_USED=$(free -h 2>/dev/null | awk '/Mem:/{print $3}' || echo "N/A")
SWAP_TOTAL=$(free -h 2>/dev/null | awk '/Swap:/{print $2}' || echo "N/A")

# GPU
GPU=$(lspci 2>/dev/null | grep -iE 'vga|3d|display' | sed 's/.*: //' || echo "N/A")
GPU_COUNT=$(lspci 2>/dev/null | grep -cE 'vga|3d|display' || echo "0")

# Desktop
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    DESKTOP="${XDG_CURRENT_DESKTOP:-unknown} su Wayland"
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    DESKTOP="${XDG_CURRENT_DESKTOP:-unknown} su X11"
elif [ -n "$XDG_CURRENT_DESKTOP" ]; then
    DESKTOP="$XDG_CURRENT_DESKTOP"
else
    DESKTOP="TTY/headless"
fi

# Storage
STORAGE=$(lsblk -d -o NAME,SIZE,MODEL,ROTA 2>/dev/null | grep -v loop || echo "N/A")

# Network
NET_IFACES=$(ip -o link show 2>/dev/null | grep -v "lo:" | awk -F': ' '{print $2}' | paste -sd ', ' || echo "N/A")
NET_ETH=$(lspci 2>/dev/null | grep -i ethernet | sed 's/.*: //' | head -3 || echo "N/A")
NET_WIFI=$(lspci 2>/dev/null | grep -i network | sed 's/.*: //' | head -3 || echo "N/A")
IP_LOCAL=$(ip -4 addr show 2>/dev/null | grep -oP 'inet \K[\d.]+' | grep -v '127.0.0.1' | head -1 || echo "N/A")

# Audio
AUDIO=$(lspci 2>/dev/null | grep -i audio | sed 's/.*: //' || echo "N/A")

# Monitor
if command -v xrandr &>/dev/null; then
    MONITOR_INFO=$(xrandr --query 2>/dev/null | grep " connected" | awk '{print $1, $3, $4}' || echo "N/A")
    MONITOR_COUNT=$(echo "$MONITOR_INFO" | grep -c . || echo "0")
elif command -v wlr-randr &>/dev/null; then
    MONITOR_INFO=$(wlr-randr 2>/dev/null | grep -E "^[A-Z]" || echo "N/A (Wayland compositor non standard)")
    MONITOR_COUNT=$(echo "$MONITOR_INFO" | grep -c . || echo "0")
else
    MONITOR_INFO="N/A (nessun xrandr disponibile)"
    MONITOR_COUNT="N/A"
fi

# UPS / Battery
if [ -d /sys/class/power_supply/BAT0 ]; then
    BAT_CAP=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "N/A")
    BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "N/A")
    BATTERY="${BAT_CAP}% (${BAT_STATUS})"
else
    BATTERY="N/A (desktop/alimentato)"
fi

# --- SCRITTURA PROFILO ---

cat > "$DIR/PROFILO.md" << EOF
# Profilo PC: $HOST

## Identità
| Campo | Valore |
|---|---|
| **Machine ID** | $MACHINE_ID |
| **Modello** | $VENDOR $MODEL |
| **Chassis** | $CHASSIS_NAME |
| **Hostname** | $HOST |

---

## Sistema Operativo

| Campo | Valore |
|---|---|
| **OS** | $OS_NAME |
| **Kernel** | $KERNEL |
| **Arch** | $ARCH |
| **Desktop** | $DESKTOP |
| **Shell** | $SHELL |
| **Pacchetti** | $PACKAGE_COUNT installati |
| **Uptime** | $UPTIME |

---

## Hardware

### CPU
- **$CPU**
- $CPU_CORES core
- Architettura: $CPU_ARCH
- Max freq: $CPU_MAX_MHZ MHz

### GPU ($GPU_COUNT GPU)
$GPU
$(if [ "$MONITOR_COUNT" != "N/A" ] && [ "$MONITOR_COUNT" != "0" ]; then
  echo ""
  echo "### Monitor ($MONITOR_COUNT display)"
  echo "\`\`\`"
  echo "$MONITOR_INFO"
  echo "\`\`\`"
fi)

### RAM
- Totale: **$RAM_TOTAL**
- Usata: $RAM_USED (al momento della rilevazione)
- Swap: $SWAP_TOTAL

### Storage
\`\`\`
$STORAGE
\`\`\`

### Rete
- **Interfacce:** $NET_IFACES
- **Ethernet:** $NET_ETH
- **Wi-Fi:** $NET_WIFI
- **IP locale:** $IP_LOCAL

### Audio
$AUDIO

### Batteria / Alimentazione
- $BATTERY

---

## Configurazione Pi

*Da compilare dopo il bootstrap*

### Problemi noti
*(nessuno ancora registrato)*

### Storico interventi
| Data | Intervento |
|---|---|
| $(date +%d/%m/%Y) | Creazione profilo |
EOF

echo ""
echo "✅ PROFILO.md creato in $DIR/PROFILO.md"

# --- CERCA MONITOR per generare script ripristino ---
if command -v xrandr &>/dev/null; then
    MONITOR_COUNT_CHECK=$(xrandr --query 2>/dev/null | grep -c " connected" || echo "0")
    if [ "$MONITOR_COUNT_CHECK" -gt 0 ]; then
        echo "▶ Trovati $MONITOR_COUNT_CHECK monitor collegati"
        MONITOR_MODEL=$(xrandr --query | grep " connected" | head -2 | sed 's/.*connected //' | xargs)

        cat > "$DIR/ripristino_monitor.sh" << 'MONEOF'
#!/bin/bash
# ============================================================
# Ripristino monitor
# I comandi xrandr esatti vanno copiati qui.
# Usa: xrandr --query
# Poi: xrandr --output <NOME> --mode <RIS> --pos <XxY> --rotate <normale|left|right>
# ============================================================

echo "Ripristino layout monitor..."
echo ""
echo "Monitor attuali:"
xrandr --query | grep " connected"
echo ""
echo "⚠️  AGGIUNGI QUI I COMANDI XRANDR PER IL TUO LAYOUT"
echo "   Esempio: xrandr --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normale"
MONEOF
        chmod +x "$DIR/ripristino_monitor.sh"
        echo "▶ Generato template ripristino_monitor.sh"
    fi
fi

# --- BACKUP CONFIG KDE (se presente) ---
if [ -f "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" ]; then
    cp "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" "$DIR/plasma-desktop-appletsrc.backup" 2>/dev/null
    echo "▶ Salvato backup pannelli KDE"
fi
if [ -f "$HOME/.config/kdeglobals" ]; then
    cp "$HOME/.config/kdeglobals" "$DIR/kdeglobals.backup" 2>/dev/null
    echo "▶ Salvato backup tema KDE"
fi
if [ -f "$HOME/.config/baloofilerc" ]; then
    cp "$HOME/.config/baloofilerc" "$DIR/baloofilerc.backup" 2>/dev/null
    echo "▶ Salvato backup baloo config"
fi

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║            PROFILO CREATO CON SUCCESSO            ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "📄 $DIR/PROFILO.md"
echo ""
echo "▶ Aggiungi problemi noti e storico interventi manualmente"
echo "▶ Ora apri Pi e prova: 'su che PC sono'"
