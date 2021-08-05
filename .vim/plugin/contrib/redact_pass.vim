" from https://github.com/bobrippling/password-store/blob/master/contrib/vim/redact_pass.vim
" upstream https://git.zx2c4.com/password-store/tree/contrib/vim/redact_pass.vim
"
" redact_pass.vim: Switch off the 'viminfo', 'backup', 'writebackup',
" 'swapfile', and 'undofile' globally when editing a password in pass(1).
"
" This is to prevent anyone being able to extract passwords from your Vim
" cache files in the event of a compromise.
"
" Author: Tom Ryder <tom@sanctum.geek.nz>
" License: Same as Vim itself
"

" Check whether we should set redacting options or not
function! s:CheckArgsRedact()
  " Disable all the leaky options globally
  set nobackup
  set nowritebackup
  set noswapfile
  set viminfo=
  if has('persistent_undo')
    set noundofile
  endif

  " Tell the user what we're doing so they know this worked, via a message and
  " a global variable they can check
  redraw
  echohl WarningMsg
  echomsg 'Editing password file, disabled leaky options'
  echohl None
  let b:redact_pass_redacted = 1
endfunction

" Auto function loads only when Vim starts up
augroup redact_pass
  autocmd!
  autocmd VimEnter
        \ /dev/shm/pass.?*/?*.txt
        \,$TMPDIR/pass.?*/?*.txt
        \,/tmp/pass.?*/?*.txt
        \ call s:CheckArgsRedact()
  " Work around macOS' dynamic symlink structure for temporary directories
  if has('mac')
    autocmd VimEnter
          \ /private/var/?*/pass.?*/?*.txt
          \ call s:CheckArgsRedact()
  endif
augroup END
