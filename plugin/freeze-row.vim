let g:split_opened = 0
let g:frozen_line = 0
let g:frozen_line_top = 0
let g:frozen_line_bottom = 0
let g:is_frozen_active = 0

function! ToggleSplit()
    au! CursorMoved * " Temporarily disable CursorMoved autocommand

    if g:split_opened
        if winnr('$') == 1 " Check if there's only one window
            return
        endif
        wincmd o
        let g:split_opened = 0
        let g:frozen_line_top = 0
        let g:frozen_line_bottom = 0
        let g:is_frozen_active = 0
    else
        if !g:is_frozen_active
            let g:is_frozen_active = 1
        endif

        let target_line = line('.')
        let g:frozen_line = target_line
        let g:frozen_line_top = target_line - 2 " Set the top frozen line based on cursor position
        let g:frozen_line_bottom = target_line + 18 " Set the bottom frozen line based on cursor position

        " Open and resize the split dynamically
        execute "normal! mz" | split | set scrollbind | execute 'normal! ' . target_line . 'G'
        let winheight = winheight(0) " Get current window height
        let resize_count = winheight / 5 " Calculate resize count based on window height
        execute "normal! " . resize_count . "\<C-w>-"

        " Move focus to the original window and adjust cursor position
        wincmd p
        execute "normal! " . g:frozen_line . "G"

        let g:split_opened = 1
    endif

    au CursorMoved * call AutoToggleSplit() " Re-enable CursorMoved autocommand
endfunction

function! AutoToggleSplit()
    if g:split_opened && line('.') < g:frozen_line_top
        if winnr('$') == 1 " Check if there's only one window
            return
        endif
        wincmd o
        let g:split_opened = 0
    elseif !g:split_opened && line('.') >= g:frozen_line_bottom && line('.') <= line('$') - 14 && g:frozen_line != 0 && g:is_frozen_active
        let target_line = line('.') - g:frozen_line_bottom + g:frozen_line

        " Open and resize the split dynamically
        execute "normal! mz" | split | set scrollbind | execute 'normal! ' . target_line . 'G'
        let winheight = winheight(0) " Get current window height
        let resize_count = winheight / 5 " Calculate resize count based on window height
        execute "normal! " . resize_count . "\<C-w>-"

        " Move focus to the original window and adjust cursor position
        wincmd p
        execute "normal! " . g:frozen_line . "G"

        let g:split_opened = 1
    endif
endfunction

autocmd CursorMoved,MouseWheel,CursorPage * call AutoToggleSplit()

nnoremap <leader>fr :call ToggleSplit()<CR>
