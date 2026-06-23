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
