#!/usr/bin/env bash
# ==============================================================================
# Gerenciador de Dotfiles (Bare Repository) com Travas de Segurança e Fast-Sync
# ==============================================================================

GIT_CMD="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# --- TRAVA 1: Atalho de Sincronização Rápida (dotfiles sync "mensagem") ---
if [ "$1" = "sync" ]; then
    if [ -z "$2" ]; then
        echo -e "\033[1;31m[ERRO]\033[0m Forneça uma mensagem de commit!"
        echo "Uso: dotfiles sync \"sua mensagem de commit\""
        exit 1
    fi
    echo -e "\033[1;34m[Dotfiles]\033[0m Adicionando alterações em arquivos já rastreados..."
    $GIT_CMD add -u
    echo -e "\033[1;34m[Dotfiles]\033[0m Criando commit..."
    $GIT_CMD commit -m "$2"
    echo -e "\033[1;34m[Dotfiles]\033[0m Enviando para o repositório remoto..."
    $GIT_CMD push
    exit $?
fi

# --- TRAVA 2: Bloqueio de 'dotfiles add .' e pastas inteiras perigosas ---
if [ "$1" = "add" ]; then
    for arg in "${@:2}"; do
        if [[ "$arg" == "." || "$arg" == "-A" || "$arg" == "--all" ]]; then
            echo -e "\033[1;31m[ANTI-BURRICE]\033[0m Comando 'dotfiles add $arg' BLOQUEADO!"
            echo "Adicionar a raiz da Home vai incluir milhares de arquivos indesejados e credenciais."
            echo "Adicione apenas arquivos ou subpastas específicas (ex: dotfiles add ~/.config/waybar/)."
            exit 1
        fi
        if [[ "$arg" == "$HOME/.config" || "$arg" == "$HOME/.config/" || "$arg" == ".config" || "$arg" == ".config/" ]]; then
            echo -e "\033[1;31m[ANTI-BURRICE]\033[0m Comando 'dotfiles add $arg' BLOQUEADO!"
            echo "Não adicione a pasta .config inteira! Especifique a subpasta (ex: dotfiles add ~/.config/foot/)."
            exit 1
        fi
    done
fi

# --- TRAVA 3: Bloqueio de 'dotfiles rm' sem a flag --cached ---
if [ "$1" = "rm" ]; then
    has_cached=false
    for arg in "${@:2}"; do
        if [[ "$arg" == "--cached" ]]; then
            has_cached=true
            break
        fi
    done

    if [ "$has_cached" = false ]; then
        echo -e "\033[1;31m[ANTI-BURRICE]\033[0m Comando 'dotfiles rm' sem --cached BLOQUEADO!"
        echo "Executar 'dotfiles rm' sem '--cached' vai APAGAR O ARQUIVO FÍSICO do seu SSD!"
        echo -e "Use: \033[1;32mdotfiles rm --cached <arquivo>\033[0m para remover apenas do Git."
        exit 1
    fi
fi

# Substitui o processo atual pelo binário do Git
exec $GIT_CMD "$@"
