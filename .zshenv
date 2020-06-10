# zshrc is only loaded for interactive shells
# zshenv is loaded for all

source ~/.environ_script

if [[ -n "$PS1" ]] && [[ -t 0 ]] && [[ -t 1 ]] && [[ -t 2 ]]
then
	source ~/.environ_interactive
	source ~/.aliases
fi
