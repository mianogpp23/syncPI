#!/bin/bash
# ============================================================
# bootstrap-pi.sh
# Configura Pi + profilo PC da zero su un nuovo PC.
# Usare dopo aver clonato il repo profili sul nuovo PC.
# ============================================================
set -e

# URL della repo profili (cambiare con la propria)
GIT_REPO="https://github.com/mianogpp23/syncPI.git"

echo "╔══════════════════════════════════════════════════╗"
echo "║          Bootstrap Pi + Profilo PC               ║"
echo "╚══════════════════════════════════════════════════╝"

# --- 1. INSTALLA Pi ---
if ! command -v pi &>/dev/null; then
    echo ""
    echo "[1/5] Installazione Pi..."
    curl -fsSL https://pi.dev/install.sh | sh
    echo "✅ Pi installato"
else
    PI_VER=$(pi --version 2>/dev/null || echo "?")
    echo "[1/5] Pi già installato (v$PI_VER)"
fi

# --- 2. CLONA REPO PROFILI (se non già presente) ---
PROFILI_DIR="$HOME/progetti/profili"
if [ ! -d "$PROFILI_DIR" ]; then
    echo ""
    if [ -z "$GIT_REPO" ]; then
        echo "[2/5] Inserisci la URL del repo git dei profili (es. https://github.com/tuo-user/profili-pc.git):"
        echo -n "   URL: "
        read -r GIT_REPO
        if [ -z "$GIT_REPO" ]; then
            echo "❌ Nessuna URL fornita. Impossibile clonare."
            echo "   Crea prima la repo su GitHub, poi esegui di nuovo questo script."
            exit 1
        fi
    fi
    echo "[2/5] Clonazione repo profili..."
    mkdir -p "$HOME/progetti"
    git clone "$GIT_REPO" "$PROFILI_DIR"
    echo "✅ Repo clonato in $PROFILI_DIR"
else
    echo "[2/5] Cartella profili già presente in $PROFILI_DIR"
    cd "$PROFILI_DIR"
    git pull --rebase 2>/dev/null && echo "   → Sincronizzata"
fi

# --- 3. INSTALLA SKILL PROFILO-PC ---
echo ""
echo "[3/5] Installazione skill profilo-pc..."
SKILL_DEST="$HOME/.pi/agent/skills/profilo-pc"
mkdir -p "$(dirname "$SKILL_DEST")"
if [ -d "$SKILL_DEST" ]; then
    echo "   Skill già presente, aggiorno..."
    rm -rf "$SKILL_DEST"
fi
cp -r "$PROFILI_DIR/skills/profilo-pc" "$SKILL_DEST"
echo "✅ Skill installata in $SKILL_DEST"

# --- 4. CREA PROFILO PER QUESTO PC ---
HOST=$(hostname)
echo ""
echo "[4/5] Creazione profilo per questo PC ($HOST)..."
if [ -f "$PROFILI_DIR/$HOST/PROFILO.md" ]; then
    echo "   Profilo per $HOST esiste già. Vuoi rigenerarlo? [s/N]"
    read -r RIGENERA
    if [ "$RIGENERA" = "s" ] || [ "$RIGENERA" = "S" ]; then
        rm -rf "$PROFILI_DIR/$HOST"
        bash "$PROFILI_DIR/nuovo_profilo.sh"
    else
        echo "   → Mantenuto profilo esistente"
    fi
else
    bash "$PROFILI_DIR/nuovo_profilo.sh"
fi

# --- 5. CONFIGURA PI SETTINGS DI BASE ---
echo ""
echo "[5/5] Verifica configurazione Pi..."
PI_SETTINGS="$HOME/.pi/agent/settings.json"
if [ -f "$PI_SETTINGS" ]; then
    echo "   File settings.json già presente"
    echo "   → Verifica che i pacchetti/estensioni siano quelli desiderati"
    echo "   → Modifica manualmente se necessario: $PI_SETTINGS"
else
    echo "   ⚠️  Nessun settings.json trovato"
    echo "   → Dovrai configurare provider e modello con /login e /model"
fi

# --- RIEPILOGO ---
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║               BOOTSTRAP COMPLETATO                ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "📁 Profilo PC:     $PROFILI_DIR/$HOST/PROFILO.md"
echo "🔧 Skill Pi:       $SKILL_DEST/SKILL.md"
echo ""
echo "▶ Ora apri Pi e prova:"
echo "   • 'su che PC sono'  — per vedere il profilo caricato"
echo "   • 'mostra profilo'  — per vedere i dettagli hardware"
echo ""
echo "▶ Dopo modifiche ai profili, sincronizza con:"
echo "   cd $PROFILI_DIR && git add -A && git commit -m \"...\" && git push"
echo ""
