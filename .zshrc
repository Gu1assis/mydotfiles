# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
# Default
plugins=(git)

source $ZSH/oh-my-zsh.sh
alias ohmyzsh="mate ~/.oh-my-zsh"

# Minha configuracao
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Alias
alias docs="/mnt/c/Users/Usuario/Documents/Linux_Docs"
alias v="nvim"
alias dotfiles="$HOME/.config/dotfiles/dotfiles_cli.sh"

fastfetch
dotfiles notify

# Avisar sobre alteracoes no REMOTE ao entrar num repo git.
source ~/myScripts/bash/check_git_changes.sh
cd() {
    builtin cd "$@" && check_git_upstream
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
