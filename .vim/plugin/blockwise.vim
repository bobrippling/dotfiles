" Vim global plugin for restricting colon commands to visual blocks
" Maintainer:	Damian Conway
" License:	This file is placed in the public domain.

" Preserve external compatibility options, then enable full vim compatibility...
let s:save_cpo = &cpo
set cpo&vim


"=====[ Custom settings ]===================
let g:Blockwise_default_mapping = 0
let g:Blockwise_autoselect = 1

"=====[ Interface ]===================

if !exists('g:Blockwise_selector')
    let g:Blockwise_selector = 'B'
endif
if strlen(g:Blockwise_selector) && g:Blockwise_default_mapping
    exec 'xnoremap  ' . g:Blockwise_selector . ' :Blockwise<SPACE>'
endif

if exists('g:Blockwise_autoselect')
    if g:Blockwise_autoselect
        xmap <expr> : VBCautoselect()
    endif
endif

if exists("&inccommand")
    lua << trim EOF
    local function preview(opts, hl_namespace, preview_buf)
        local generated_cmd = opts.line1
        .. ","
        .. opts.line2
        .. opts.name
        .. " "
        .. opts.args

        -- override start/end - visual mode isn't active at this point
        vim.api.nvim_buf_set_var(0, 'blockwise_start', vim.fn.getpos("'<"))
        vim.api.nvim_buf_set_var(0, 'blockwise_end', vim.fn.getpos("'>"))

        -- vim.api.nvim_buf_set_lines(preview_buf, 0, 0, false, { ... })
        vim.cmd(generated_cmd)

        vim.api.nvim_buf_del_var(0, 'blockwise_start')
        vim.api.nvim_buf_del_var(0, 'blockwise_end')

        -- no preview window
        return 1
    end

    vim.api.nvim_create_user_command(
        'Blockwise',
        'silent call VBCexec(<q-args>)',
        {
          nargs = '+',
          range = 1,
          bar = true,
          complete = 'command',
          preview = preview,
          force = true,
        }
    )
    EOF
else
    command! -bar -range -nargs=+ -com=command Blockwise silent call VBCexec(<q-args>)
endif

command! -bar -range -nargs=* -bang SortByBlock silent call VBCsort('<bang>', <q-args>)


"=====[ Implementation ]===================

function! VBCexec(cmd) range
    " Just execute as normal in visual line mode...
    if visualmode() ==# "V"
        exec '''<,''>' . a:cmd
        normal gv
        return
    endif

    " Remember the length of the buffer...
    let orig_buflen = line('$')

    " Locate and record block being shifted...
    let [buf_left,  line_left,  col_left,  offset_left ] = get(b:, "blockwise_start", getpos("'<"))
    let [buf_right, line_right, col_right, offset_right] = get(b:, "blockwise_end", getpos("'>"))

    " Split lines into columns around selected block...
    if visualmode() == "\<C-V>"
        let lines_left   = getline(line_left, line_right)
        let lines_middle = copy(lines_left)
        let lines_right  = copy(lines_left)

        for n in range(len(lines_left))
            let lines_left[n]   = col_left > 1 ? lines_left[n][0 : col_left-2] : ""
            let lines_middle[n] = lines_middle[n][col_left-1 : col_right-1]
            let lines_right[n]  = lines_right[n][col_right : ]
        endfor

    " Split off unselected ends of first and last line...
    else
        let lines_middle = getline(line_left, line_right)
        let line_maxidx  = len(lines_middle)-1
        let lines_left   = repeat([''], line_maxidx+1)
        let lines_right  = repeat([''], line_maxidx+1)

        let lines_left[0]             = col_left > 1 ? lines_middle[0][0 : col_left-2] : ""
        let lines_right[line_maxidx]  = lines_middle[line_maxidx][col_right : ]

        let lines_middle[line_maxidx] = lines_middle[line_maxidx][0 : col_right-1 ]
        let lines_middle[0]           = lines_middle[0][col_left-1 : ]
    endif

    " Remember whether we were previously modified
    let orig_modified = &l:modified

    " Temporarily allow modifications for setline() changes
    let orig_modifiable = &l:modifiable
    setlocal modifiable

    " Remove the before and aft in visual block mode...
    call setline(line_left, lines_middle)

    " See if the following command modifies...
    setlocal nomodified

    " But keep 'modifiable' for the context of the following command
    let &l:modifiable = orig_modifiable

    " Execute the commands...
    exec '''<,''>' . a:cmd

    let modified_after_subcmd = &l:modified

    " Allow us to change lines again
    setlocal modifiable

    " Adjust the line count...
    let bufdiff = orig_buflen - line('$')
    if bufdiff > 0
        " Fewer lines left, so insert sufficient empty lines...
        call append(line_right - bufdiff, repeat([repeat(' ', col_right-col_left+1)], bufdiff))

    elseif bufdiff < 0
        " More lines left, so add extras...
        let lines_left  += repeat([repeat(' ', col_left-1)], -bufdiff)
        let lines_right += repeat([''], -bufdiff)
    endif

    " Reconstruct the lines...
    for n in range(len(lines_left))
        call setline(line_left + n, lines_left[n] . getline(line_left + n) . lines_right[n])
    endfor

    " Restore 'modifiable'
    let &l:modifiable = orig_modifiable

    " Restore 'modified'
    if orig_modified
        " Should be 'modified' already from setline(), but for completeness
        setlocal modified
    elseif !modified_after_subcmd
        " Subcommand didn't modify, so don't let our setline() "modification" take effect
        setlocal nomodified
    endif

    " Restore the selection...
    normal gv

endfunction


function! VBCsort(bang, options) range
    " Locate and record block being shifted...
    let [buf_left,  line_left,  col_left,  offset_left ] = getpos("'<")
    let [buf_right, line_right, col_right, offset_right] = getpos("'>")

    " If no options given, detect the type of sort required...
    if !len(a:options)
        let lines   = getline(line_left, line_right)
        let matches = filter(copy(lines), 'match(v:val['.(col_left-1).':'.(col_right-1).'], "^\\s*\\d") >= 0')
        let numeric = (len(lines) == len(matches)) ? 'n' : ''
        let options = ' '. numeric .' /.*\%' . col_left . 'v/'
    else
        let options = ' '. a:options .' /\%>'. (col_left-1) .'v.\{-}\%<'. (col_right+1) .'v./ r'
    endif

    " Remove the before and aft...
    exec line_left .','. line_right .' sort' . a:bang . ' ' . options

    " Restore the selection...
    normal gv

endfunction

function! VBCautoselect ()
    if mode() ==# 'V'
        return ':'
    else
        return ':Blockwise '
    endif
endfunction


" Restore previous external compatibility options
let &cpo = s:save_cpo
