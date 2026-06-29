#!/bin/bash
# ============================================================
# Ripristino monitor - PC: k10 (Lenovo ThinkCentre M93p)
# 2× AMD FirePro W600 - 12 monitor
# Generato: 22/06/2026 - Aggiornato: 22/06/2026
# ============================================================

echo "Ripristino layout 12 monitor..."
echo "Spegnimento output..."

for dp in DP-1 DP-2 DP-3 DP-4 DP-5 DP-6 DP-7 DP-8 DP-9 DP-10 DP-11 DP-12; do
    xrandr --output "$dp" --off 2>/dev/null || true
done

echo "Applicazione layout..."

xrandr --output DP-11 --mode 1920x1200 --pos 0+0 --rotate normal
xrandr --output DP-5  --mode 1366x768  --pos 1920+432 --rotate normal
xrandr --output DP-8  --mode 1920x1080 --pos 3286+120 --rotate normal
xrandr --output DP-7  --mode 1366x768  --pos 5206+432 --rotate normal
xrandr --output DP-3  --mode 1680x1050 --pos 6572+150 --rotate normal

xrandr --output DP-1  --mode 947x1684  --pos 151+1200 --rotate left --primary
xrandr --output DP-4  --mode 1050x1680 --pos 1099+1200 --rotate right
xrandr --output DP-6  --mode 1920x1200 --pos 3286+1200 --rotate normal
xrandr --output DP-9  --mode 1105x1768 --pos 5206+1200 --rotate right
xrandr --output DP-2  --mode 1105x1768 --pos 6312+1200 --rotate left
xrandr --output DP-12 --mode 1137x2021 --pos 2149+1200 --rotate right
xrandr --output DP-10 --mode 1137x2021 --pos 7418+1200 --rotate right

echo "✅ Layout 12 monitor ripristinato (DP-1 primario)"
