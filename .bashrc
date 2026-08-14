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

alias h="cd $HOME"
alias v="vim"
alias nv="nvim"
alias batt="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage"
alias doc="cd ~/Docs/Linux_Docs && nvim ."
alias liv="cd ~/Docs/livros && nvim ."
alias restartwaybar="~/.config/waybar/restart.sh"
alias zath="cd $HOME/Docs/livros && zathura & disown && exit"
