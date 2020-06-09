# zshrc is only loaded for interactive shells
# zshenv is loaded for all

source ~/.environ_script

if test -n "$PS1"
then
	source ~/.environ_interactive
	source ~/.aliases
fi
