#!/usr/bin/env bash

# Histórico fica no cache local para não poluir o repositório do Git
HIST_FILE="$HOME/.cache/wmenu_history"
touch "$HIST_FILE"

# 1. Puxa os apps abertos antes (do mais recente ao antigo)
# 2. Lista os binários do sistema
# 3. Remove duplicados dando prioridade à ordem do histórico
# 4. Abre o wmenu com os argumentos passados, registra e executa
# Versão ultra-leve, centralizada e vertical usando o fuzzel
{
    tac "$HIST_FILE"
    compgen -c | sort -u
} | awk '!seen[$0]++' | fuzzel --dmenu | tee -a "$HIST_FILE" | ${SHELL:-"/bin/sh"} -s

