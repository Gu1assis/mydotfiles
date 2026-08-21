#!/usr/bin/env bash
# A simple script to fuzzyfind packages using eix

SELECTION=$(eix --only-names "" | \
    fzf --header="[Enter] Copiar pacote | [Esc] Sair" \
        --preview 'eix --compact {}' \
        --preview-window=right:60%:wrap)

# Se algum pacote foi selecionado, copia via wl-copy
if [ -n "$SELECTION" ]; then
    if command -v wl-copy &> /dev/null; then
        echo -n "$SELECTION" | wl-copy
        echo "Copiado para a área de transferência (Wayland): $SELECTION"
    else
        echo "Aviso: 'wl-clipboard' não encontrado. Pacote selecionado: $SELECTION"
    fi
fi
