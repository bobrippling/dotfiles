autoload -Uz compinit
compinit # for compdef in aliases

source ~/.aliases
source ~/.environ


# Run `zsh-newuser-install [-f]` to reset settings

# -------------------------------------------------------------------------------------
# The following lines were added by compinstall

zstyle ':completion:*' auto-description '%d'
zstyle ':completion::complete:*' cache-path ~/.zshcache
zstyle ':completion:*' completer _oldlist _complete _ignored _match _prefix
zstyle ':completion:*' expand prefix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' group-name ''
zstyle ':completion:*:scp:*' group-order files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:scp:*' group-order files all-files hosts-domain hosts-host hosts-ipaddr
#zstyle ':completion:*' hosts off
zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' '' 'r:|[._-]=** r:|=**'
zstyle ':completion:*' match-original both
zstyle ':completion:*' max-errors 0 not-numeric
zstyle ':completion:*' menu select=1
zstyle ':completion:*' old-list always
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt '(%e errors found)'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' tag-order files 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' tag-order files 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' use-cache on
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/rob/.zshrc'

zshrc_cursor_block(){
	printf '\x1b[2 q'
}
zshrc_cursor_bar(){
	printf '\x1b[6 q'
}
zle-keymap-select(){
	if [[ $KEYMAP = vicmd ]]
	then zshrc_cursor_block
	elif [[ $KEYMAP = main ]]
	then zshrc_cursor_bar
	fi
}
zle -N zle-keymap-select
zle-line-init(){
	zshrc_cursor_bar
}
zle -N zle-keymap-init
preexec(){
	zshrc_cursor_block
}

# End of lines added by compinstall

# -------------------------------------------------------------------------------------
# Enable colours

autoload colors && colors

# -------------------------------------------------------------------------------------
# Options

# _:s are optional
setopt append_history
setopt auto_pushd
setopt bsd_echo # no auto echo -e
setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt inc_append_history

unsetopt extended_glob # don't want ^ expanding
unsetopt share_history
unsetopt hist_beep
unsetopt beep
unsetopt correct_all
unsetopt nomatch # no-matches aren't errors

# -------------------------------------------------------------------------------------
# Environment

HISTIGNORE="ls:exit:clear:logout"
HISTTIMEFORMAT="[%Y-%m-%d - %H:%M:%S] "
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

#WORDCHARS='*?_-.[]~\!#$%^(){}<>|`@#$%^*()+:?'
WORDCHARS='*?~\!#$%^()[]{}<>|`@:'

# -------------------------------------------------------------------------------------
# Bindings

bindkey -v
bindkey -M vicmd 'k' history-beginning-search-backward
bindkey -M vicmd 'j' history-beginning-search-forward

autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line


# -------------------------------------------------------------------------------------
# Prompt
col_failure='[1;31m'

if test $UID -eq 0
then col_prompt=
else
	case "$(hostname)" in
		egbert)
			col_prompt='[34m'
			;;
		jeffraw)
			col_prompt='[38m'
			;;
		rip)
			col_prompt='[32m'
			;;
		*)
			col_prompt='[33m'
			;;
	esac
fi

# %(test.success.failure)
#  e.g. %(?.EXIT_SUCCESS.EXIT_FAILURE)
# colours should be inside a %{ %} pair

col_reset='%{[m%}'
col_bracket="%{$col_prompt%}"
col_red="%{$col_red%}"

export PS1="
%{%(?.$col_prompt.$col_red)%}%? %{$col_prompt%}%j$col_reset %# "
