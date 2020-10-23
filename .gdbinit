# display
set print array  on
set print pretty on
set backtrace limit 1000
set style enabled

# behaviour
set unwindonsignal on
set confirm off
#set disassemble-next-line on

# history
set history save
set history size 1000
set history filename ~/.gdb_history

#source ~/src/peda/peda.py

# show values
# find A, B, <bytes>
# p &head
# p $->next <enter> <enter> ...
