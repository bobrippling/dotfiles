# display
set print array  on
set print pretty on
set backtrace limit 1000
set style enabled

# behaviour
set unwindonsignal on
set confirm on
#set disassemble-next-line on

# threads
## resume all threads on `continue`, `next`, etc
set schedule-multiple on

set disassemble-next-line auto

# history
set history save
set history size 1000
set history filename ~/.gdb_history

alias enhance-peda = source ~/src/peda/peda.py
alias enhance-dashboard = source ~/src/gdb-dashboard/.gdbinit

# show values
# find A, B, <bytes>
# p &head
# p $->next <enter> <enter> ...
