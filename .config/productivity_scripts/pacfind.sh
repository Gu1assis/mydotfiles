#!/usr/bin/env bash
# Um script simples que procura pacotes por nome com fzf
# Suporte a gentoo usando o eix (lembre-se de usar eix-update na primeira vez)
# e suporte ao apt nas distros baseadas em Debian.

if ! command -v fzf &> /dev/null; then
    echo "Erro: 'fzf' não está instalado." >&2
    exit 1
fi

if command -v eix &> /dev/null; then
    PKG_LIST_CMD='eix --only-names ""'
    PREVIEW_CMD='eix --compact {}'
elif command -v apt-cache &> /dev/null; then
    PKG_LIST_CMD='apt-cache pkgnames | sort'
    PREVIEW_CMD='apt info {} 2>/dev/null'
else
    echo "Erro: Nenhum gerenciador de pacotes suportado (eix ou apt-cache) foi encontrado." >&2
    exit 1
fi

SELECTION=$(eval "$PKG_LIST_CMD" | \
    fzf --header="[Enter] Copiar pacote | [Esc] Sair" \
        --preview "$PREVIEW_CMD" \
        --preview-window=right:60%:wrap)

if [ -n "$SELECTION" ]; then
    if command -v wl-copy &> /dev/null; then
        echo -n "$SELECTION" | wl-copy
        echo "Copiado (Wayland): $SELECTION"
    elif command -v xclip &> /dev/null; then
        echo -n "$SELECTION" | xclip -selection clipboard
        echo "Copiado (X11/xclip): $SELECTION"
    elif command -v xsel &> /dev/null; then
        echo -n "$SELECTION" | xsel --clipboard --input
        echo "Copiado (X11/xsel): $SELECTION"
    else
        echo "Aviso: Nenhuma ferramenta de clipboard encontrada. Pacote selecionado: $SELECTION"
    fi
fi
