source ~/.login
source ~/.aliases

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
zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' '' 'r:|[._-]=** r:|=**'
zstyle ':completion:*' match-original both
#zstyle ':completion:*' max-errors 2 numeric
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

autoload -Uz compinit
compinit
# End of lines added by compinstall
autoload colors && colors

compdef _pacman pacman-color=pacman
compdef _pacman clyde=pacman
compdef _pacman powerpill=pacman
compdef _pacman bauerbill=pacman
compdef _netcat ncat

setopt extendedglob # cp ^*.(tar|bz2|gz) . will work
setopt appendhistory
setopt extendedglob
setopt histignoredups
setopt sharehistory
setopt append_history
setopt inc_append_history
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space # ignore commands beginning with a space, e.g. " echo tim" isn't history'd
setopt hist_no_store
setopt hist_no_functions
setopt no_hist_beep
setopt hist_save_no_dups
setopt hist_expire_dups_first
setopt correct_all

unsetopt beep

## Automatically pushd - then I can go to an old dir with cd - <tab> (pick no.)
setopt AUTOPUSHD
export DIRSTACKSIZE=11 # stack size of eleven gives me a list with ten entries


bindkey -v # vi mode
# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
#function zle-line-init zle-keymap-select {
#  # Right side prompt
#  #RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#  RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#  RPS2=$RPS1
#  zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select


# zsh Options
#   setopt             \
#    NO_all_export       \
#       always_last_prompt   \
#    NO_always_to_end    \
#       append_history     \
#    NO_auto_cd        \
#       auto_list      \
#       auto_menu      \
#    NO_auto_name_dirs     \
#       auto_param_keys    \
#       auto_param_slash   \
#       auto_pushd       \
#       auto_remove_slash  \
#    NO_auto_resume      \
#       bad_pattern      \
#       bang_hist      \
#    NO_beep         \
#       brace_ccl      \
#       correct_all      \
#    NO_bsd_echo       \
#       cdable_vars      \
#    NO_chase_links      \
#    NO_clobber        \
#       complete_aliases   \
#       complete_in_word   \
#    correct         \
#    NO_correct_all      \
#       csh_junkie_history   \
#    NO_csh_junkie_loops   \
#    NO_csh_junkie_quotes  \
#    NO_csh_null_glob    \
#       equals         \
#       extended_glob    \
#       extended_history   \
#       function_argzero   \
#       glob         \
#    NO_glob_assign      \
#       glob_complete    \
#    NO_glob_dots      \
#       glob_subst       \
#       hash_cmds      \
#       hash_dirs      \
#       hash_list_all    \
#       hist_allow_clobber   \
#       hist_beep      \
#       hist_ignore_dups   \
#       hist_ignore_space  \
#    NO_hist_no_store    \
#       hist_verify      \
#    NO_hup          \
#    NO_ignore_braces    \
#    NO_ignore_eof       \
#       interactive_comments \
#     inc_append_history   \
#    NO_list_ambiguous     \
#    NO_list_beep      \
#       list_types       \
#       long_list_jobs     \
#       magic_equal_subst  \
#    NO_mail_warning     \
#    NO_mark_dirs      \
#    NO_menu_complete    \
#       multios        \
#       nomatch        \
#       notify         \
#    NO_null_glob      \
#       numeric_glob_sort  \
#    NO_overstrike       \
#       path_dirs      \
#       posix_builtins     \
#    NO_print_exit_value   \
#    NO_prompt_cr      \
#       prompt_subst     \
#       pushd_ignore_dups  \
#    NO_pushd_minus      \
#       pushd_silent     \
#       pushd_to_home    \
#       rc_expand_param    \
#    NO_rc_quotes      \
#    NO_rm_star_silent     \
#    NO_sh_file_expansion  \
#       sh_option_letters  \
#       short_loops      \
#    NO_sh_word_split    \
#    NO_single_line_zle    \
#    NO_sun_keyboard_hack  \
#       unset        \
#    NO_verbose        \
#       zle



HISTIGNORE="ls:ll:la:cd:exit:clear:logout"
HISTTIMEFORMAT="[%Y-%m-%d - %H:%M:%S] "
HISTFILE=~/.zsh_history
#HISTSIZE=100
SAVEHIST=1000


## Ctrl-W stops at a directory
## see http://www.zsh.org/mla/users/1995/msg00088.html
#WORDCHARS='*?_-.[]~\!#$%^(){}<>|`@#$%^*()+:?'
WORDCHARS='*?~\!#$%^()[]{}<>|`@:'


bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "^H" backward-delete-char
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix


# Numpad enter
bindkey '\eOM' accept-line

# Bash style ctrl+u and ctrl+k
bindkey "^U" backward-kill-line
bindkey "^K" vi-kill-eol


# When pressing [Up] after typing ls, only previous commands beginning with ls (the current input) will be shown
# built in:
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

# other mode is viins
bindkey -M vicmd 'k' history-beginning-search-backward
bindkey -M vicmd 'j' history-beginning-search-forward


# Custom
bindkey "^G" history-beginning-search-backward


blueprompt=0
twolineprompt=0
extrastats=1
liteprompt=1

promptcolbot=
promptcoldir=


if [[ $UID -eq 0 ]]
then
  promptcolbot=red
  promptcoldir=blue
elif [[ $blueprompt -eq 1 ]]
then
  promptcolbot=blue
  promptcoldir=blue
else
  promptcolbot=green
  promptcoldir=blue
fi


# %T    System time (HH:MM)
# %*    System time (HH:MM:SS)
# %D    System date (YY-MM-DD)
# %n    Your username
# %B | %b Begin - end bold print
# %U | %u Begin - end underlining
# %d    Your current working directory
# %~    Your current working directory, relative to ~
# %.    Your current directory (truncated), relative to ~. %2. gives two directories
# %M    The computer's hostname
# %m    The computer's hostname (truncated before the first period)
# %l    Your current tty
#
# %(test.success.failure)
#  e.g. %(?.EXIT_SUCCESS.EXIT_FAILURE)

promptpwd="%B%{$fg[$promptcoldir]%}%.%{$reset_color%}%b"

if [ $liteprompt -eq 1 ]
then
  opensquare="%{$fg[$promptcolbot]%}[%{$reset_color%}"
  closesquare="%{$fg[$promptcolbot]%}]%{$reset_color%}"

	# percent is coloured if background jobs > 1
	#percent="%#"
	#percent='%(j.n.y)%# '
	percent='%# '

  export PS1="
$opensquare%?%{$fg[$promptcolbot]%}][%{$reset_color%}$promptpwd$closesquare$percent"
else
  if [ $twolineprompt -eq 0 ]
  then
    if [ $extrastats -eq 0 ]
    then
      export PS1="
  [%{$fg[$promptcolbot]%}%n%{$reset_color%}@%{$fg[$promptcolbot]%}%m%{$reset_color%} ${promptpwd}]%# "
    else
      export PS1="
  %{$fg[$promptcolbot]%}[%{$reset_color%}%j,%?%{$fg[$promptcolbot]%}]%{$reset_color%}[%{$fg[$promptcolbot]%}%n%{$reset_color%}@%{$fg[$promptcolbot]%}%m/%l%{$reset_color%} %B%{$fg[$promptcoldir]%}${promptpwd}%{$reset_color%}%b]%# "
    fi
  else
    export PS1="
  ╔═[%j][${promptpwd}][%{$fg[red]%}%?%{$reset_color%}]
  ╚═[%{$fg[$promptcolbot]%}%n%{$reset_color%}@%{$fg[$promptcolbot]%}%m/%l%{$reset_color%}]%# "
  fi
fi


# Simple:
#export PS1="[%j][%n@%m/%l][%B%~%b][%?]%# "
# Colours
# %{$reset_color%}
# %{$fg[red]%}
# %{$fg[blue]%}
# %{$fg[green]%}
# %B - bold on
# %b - bold off
#
# %j - jobs
# %l - terminal dev
# %~ - pwd
# %? - return val
# %n - user
# %m - host
# %# - % or #

# -------------------------------------------------------------------------------------
### set title block
HOSTTITLE=${(%):-%n@%m}
TITLE=$HOSTTITLE

case $TERM in
  xterm* | *rxvt | screen)
  precmd(){
    print -Pn "\e]0;$TITLE \a"
#   if [ $UID -eq 0 ]
#   then
#     print -rP ""
#     print -rP "╔═[%j][%{$fg[red]%}%l%{$reset_color%}][%B%{$fg[blue]%}%~%{$reset_color%}%b]"
#     #[%{$fg[green]%}%?%{$reset_color%}]"
#   else
#     print -rP ""
#     print -rP "┌─[%j][%{$fg[green]%}%l%{$reset_color%}][%B%{$fg[blue]%}%~%{$reset_color%}%b]"
#     #[%{$fg[red]%}%?%{$reset_color%}]"
#   fi
  }
  preexec(){
    print -Pn "\e]0;$TITLE \a"
  }
  ;;
esac

function title (){
  if (( ${#argv} == 0 )); then
    TITLE=$HOSTTITLE
  else
    TITLE=$*
  fi
}

# Functions
# go to google for a definition
define(){
  local LNG=$(echo $LANG | cut -d '_' -f 1)
  local CHARSET=$(echo $LANG | cut -d '.' -f 2)
  local browser=lynx
  $browser -accept_all_cookies -dump -hiddenlinks=ignore -nonumbers -assume_charset="$CHARSET" -display_charset="$CHARSET" "http://www.google.com/search?hl=${LNG}&q=define%3A+${1}&btnG=Google+Search" | grep -m 5 -C 2 -A 5 -w "*" > /tmp/define
  if [ ! -s /tmp/define ]; then
  echo "No definition found."
  rm -f /tmp/define
  return 1
  else
  cat /tmp/define | grep -v Search
  echo ""
  fi
  rm -f /tmp/define
}


# pull a single file out of a .tar.gz
pullout(){
  if [ $# -ne 2 ]; then
  echo "usage: pullout [file] [archive{.tar.gz,.tgz}]"
  return 1
  fi
  case $2 in
  *.tar.gz|*.tgz) gunzip < $2 | tar -xf - $1           ;;
  *)        echo "$2 is not a valid archive" && return 1 ;;
  esac
}

# only zsh supports -g
alias -g bga='>&/dev/null&'

# open a GUI app from CLI
open(){
  $1 &>/dev/null &
}


search(){
  if [ $# -ne 1 -o "$1" = "--help" ]
  then
    echo "usage: $0 file_to_search_for" >&2
    return 1
  else
    echo "find . -iname \"\*$1\*\"" >&2
    find . -iname \*$1\*
  fi
}

searchgrep(){
  echo 'grep -Rin "$@" *'
  grep -Rin "$@" *
  # R - recursive
  # i - case insensetive
  # n - show line number
}

nh(){
  if [ $# -eq 0 ]
  then
    echo "usage: nh program [args]"
  else
    nohup $@ &> /dev/null &
    disown %nohup
  fi
}


cb(){
  if [ $# -gt 1 ]
  then
    echo "Usage: cb [file.cbp]"
    return 1
  else
    echo "codeblocks $@ &> /dev/null"
    codeblocks $@ &> /dev/null
  fi
}
