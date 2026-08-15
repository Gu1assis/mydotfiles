#!/usr/bin/env bash
# ==============================================================================
# Gerenciador de Dotfiles (Bare Repository) com Travas de Segurança e Fast-Sync
# ==============================================================================

GIT_CMD="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# --- NOTIFICAÇÃO DE ALTERAÇÕES PENDENTES (dotfiles notify) ---
if [ "$1" = "notify" ]; then
    # Verifica se há alterações locais não comitadas
    has_local_changes=$($GIT_CMD status --porcelain 2>/dev/null)
    
    # Verifica se há commits locais que não foram enviados (unpushed)
    has_unpushed=$($GIT_CMD cherry -v 2>/dev/null)

    if [ -n "$has_local_changes" ] || [ -n "$has_unpushed" ]; then
        echo -e "\033[1;33m⚠️  [Dotfiles Notice]\033[0m Você possui alterações de configuração não sincronizadas!"
        echo -e "   Rode \033[1;32mdotfiles sync \"mensagem\"\033[0m para atualizar o repositório remoto.\n"
    fi
    exit 0
fi

# --- AJUDA / HELP AUTOMÁTICO (Sem argumentos ou -h/--help) ---
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo -e "\033[1;34m🛠️  Dotfiles Manager (Bare Repository CLI)\033[0m"
    echo -e "Gerenciador e sincronizador de arquivos de configuração da Home.\n"
    
    echo -e "\033[1;33mUSO CUSTOMIZADO:\033[0m"
    echo -e "  \033[1;32mdotfiles sync \"mensagem\"\033[0m    Sincronização rápida (add -u, commit e push)"
    echo -e "  \033[1;32mdotfiles notify\033[0m               Verifica pendências locais (útil para o .bashrc/.zshrc)"
    echo -e "  \033[1;32mdotfiles -h, --help\033[0m           Exibe esta tela de ajuda\n"
    
    echo -e "\033[1;33mCOMANDOS COMUNS DO GIT (WRAPPER):\033[0m"
    echo -e "  \033[1;36mdotfiles status\033[0m             Exibe os arquivos modificados e rastreados"
    echo -e "  \033[1;36mdotfiles add <arquivo>\033[0m      Adiciona um arquivo/pasta específica ao repositório"
    echo -e "  \033[1;36mdotfiles commit -m \"msg\"\033[0m    Cria um commit local das alterações"
    echo -e "  \033[1;36mdotfiles push / pull\033[0m        Envia ou puxa alterações do GitHub"
    echo -e "  \033[1;36mdotfiles rm --cached <arq>\033[0m  Remove um arquivo do Git (MANTÉM NO DISCO)"
    echo -e "  \033[1;36mdotfiles diff\033[0m               Mostra as alterações pendentes nos arquivos\n"

    echo -e "\033[1;31mPROTEÇÕES ATIVAS:\033[0m"
    echo -e "  • Bloqueio de 'add .' e 'add ~/.config' (Prevenção contra vazamento de secrets)"
    echo -e "  • Bloqueio de 'rm' sem a flag '--cached' (Prevenção contra deleção física no disco)\n"

    echo -e "\033[1;35mDICA DE NOTIFICAÇÃO NO SHELL:\033[0m"
    echo -e "  Para receber alertas ao abrir o terminal quando houver configs pendentes, rode:"
    echo -e "  \033[1;32mecho 'dotfiles notify' >> ~/.bashrc\033[0m  (ou ~/.zshrc)\n"
    exit 0
fi

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
