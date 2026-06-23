#!/bin/bash
# ============================================================
# sync.sh
# Sincronizza i profili PC con git.
# Pull + commit modifiche locali + push.
# ============================================================

set -e

cd "$(dirname "$0")"
HOST=$(hostname)

echo "📡 Sincronizzazione profili PC..."
echo ""

# Pull prima per minimizzare conflitti
echo "⇣ git pull --rebase..."
git pull --rebase 2>&1 | sed 's/^/   /'

echo ""

# Mostra stato
STATUS=$(git status --short)
if [ -z "$STATUS" ]; then
    echo "✅ Nessuna modifica locale — già sincronizzato"
    exit 0
fi

echo "Modifiche locali rilevate:"
echo "$STATUS" | sed 's/^/   /'
echo ""

# Commit
COMMIT_MSG="sync: aggiornamento profilo $HOST ($(date +%d/%m/%Y))"
echo "⇡ git commit + push..."
git add -A
git commit -m "$COMMIT_MSG"
git push 2>&1 | sed 's/^/   /'

echo ""
echo "✅ Sincronizzazione completata per $HOST"
