# Effects
# 00  Default colour
# 01  Bold
# 04  Underlined
# 05  Flashing text
# 07  Reversetd
# 08  Concealed
# Colours
# 31  Red
# 32  Green
# 33  Orange
# 34  Blue
# 35  Purple
# 36  Cyan
# 37  Grey
# Backgrounds
# 40  Black background
# 41  Red background
# 42  Green background
# 43  Orange background
# 44  Blue background
# 45  Purple background
# 46  Cyan background
# 47  Grey background
# Extra colours
# 90  Dark grey
# 91  Light red
# 92  Light green
# 93  Yellow
# 94  Light blue
# 95  Light purple
# 96  Turquoise
# 97  White
# 100 Dark grey background
# 101 Light red background
# 102 Light green background
# 103 Yellow background
# 104 Light blue background
# 105 Light purple background
# 106 Turquoise background

black="\e[0;30m"
red="\e[0;31m"
green="\e[0;32m"
brown="\e[0;33m"
blue="\e[0;34m"
purple="\e[0;35m"
cyan="\e[0;36m"
gray="\e[0;37m"
nocolor="\e[0;0m"

BLACK="\e[1;30m"
RED="\e[1;31m"
GREEN="\e[1;32m"
BROWN="\e[1;33m"
BLUE="\e[1;34m"
PURPLE="\e[1;35m"
CYAN="\e[1;36m"
GRAY="\e[1;37m"

export LS_COLORS="no=0:fi=0:di=1;34:ln=1;36:pi=1;33:bd=44;37:cd=44;37:or=7;36:so=33:su=1;31:sg=31:tw=1;35:ow=0;34:ex=1;32:mi=31"

export LESS_TERMCAP_mb=$'\e[0;32m'
export LESS_TERMCAP_md=$'\e[0;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;34m'

gcc=0

# see http://gcc.gnu.org/onlinedocs/gcc/C_002b_002b-Dialect-Options.html#C_002b_002b-Dialect-Options
if [ $SHELL = `which bash` ]
then

	if [ $gcc -eq 0 ]
	then
		CC="tcc"
		CFLAGS="-Wall -Wunusupported -Wwrite-strings"
	else
		CC="gcc"
		CFLAGS="-march=native -O2 -fomit-frame-pointer -pipe -W -Wall -Wcast-align -Wcast-qual -Wshadow -Wnested-externs -Waggregate-return -Wbad-function-cast -Wpointer-arith -Wcast-align -Wwrite-strings -Wstrict-prototypes -Wmissing-prototypes -Winline -Wredundant-decls -Wextra -pedantic -ansi"
	fi

	CXXFLAGS="-W -Wall -Wcast-align -Wcast-qual -Wshadow -Waggregate-return -Wpointer-arith -Wcast-align -Wwrite-strings -Winline -Wredundant-decls -Wextra -pedantic -ansi -Wabi -Wctor-dtor-privacy -Wnon-virtual-dtor -Wreorder -Weffc++ -Wstrict-null-sentinel -Wno-non-template-friend -Wold-style-cast -Woverloaded-virtual -Wsign-promo"
else
	if [ $gcc -eq 0 ]
	then
		CC="tcc"
		CFLAGS=(-Wall -Wunusupported -Wwrite-strings)
	else
		CC="gcc"
		CFLAGS=(-march=native -O2 -fomit-frame-pointer -pipe -W -Wall -Wcast-align -Wcast-qual -Wshadow -Wnested-externs -Waggregate-return -Wbad-function-cast -Wpointer-arith -Wcast-align -Wwrite-strings -Wstrict-prototypes -Wmissing-prototypes -Winline -Wredundant-decls -Wextra -pedantic -ansi)
	fi
	CXXFLAGS=(-W -Wall -Wcast-align -Wcast-qual -Wshadow -Waggregate-return -Wpointer-arith -Wcast-align -Wwrite-strings -Winline -Wredundant-decls -Wextra -pedantic -ansi -Wabi -Wctor-dtor-privacy -Wnon-virtual-dtor -Wreorder -Weffc++ -Wstrict-null-sentinel -Wno-non-template-friend -Wold-style-cast -Woverloaded-virtual -Wsign-promo)
fi

export CC
export CFLAGS
export CXXFLAGS

export PREFIX="/usr"

export EDITOR="vim"
export VISUAL="vim" #gvim
export BROWSER="surf"
export XTERM="urxvt"

# history notes
# echo one two three
# echo !:n
# will echo the nth arg, 0 = echo, 1 = one, 2 = two
# echo !:$ = last, !:^ = first (1)
