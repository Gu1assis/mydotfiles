# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Put your fun stuff here.
export EDITOR="vim"
export VISUAL="vim"

alias dotfiles="$HOME/.config/dotfiles/dotfiles_cli.sh"

dotfiles notify

gitsync() {
    if [ -z "$1" ]; then
        echo "Erro: Você precisa digitar uma mensagem de commit."
        echo "Exemplo: gitsync \"minha mensagem\""
        return 1
    fi

    git add -u && git commit -m "$1" && git push
}

# fish
#if [[ $- == *i* ]]; then
#    exec fish
#fi

