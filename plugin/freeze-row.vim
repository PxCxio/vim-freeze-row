let g:split_opened = 0
let g:frozen_line = 0
let g:frozen_line_top = 0
let g:frozen_line_bottom = 0

function! ToggleSplit()
  au! CursorMoved *  " Temporarily disable CursorMoved autocommand

  if g:split_opened
    wincmd o
    let g:split_opened = 0
    let g:frozen_line_top = 0
    let g:frozen_line_bottom = 0
  else
    let target_line = line('.')
    let g:frozen_line = target_line
    let g:frozen_line_top = target_line - 2  " Set the top frozen line based on cursor position
    let g:frozen_line_bottom = target_line + 6 " Set the bottom frozen line based on cursor position
    execute "normal! mz" | split | set scrollbind | execute 'normal! ' . target_line . 'G'
    " Resize the split 8 times
    execute "normal! 8\<C-w>-"

    " Move focus to the new split after resizing
    wincmd w

    let g:split_opened = 1
  endif

  au CursorMoved * call AutoToggleSplit()  " Re-enable CursorMoved autocommand
endfunction

function! AutoToggleSplit()
  if g:split_opened && line('.') < g:frozen_line_top
    if winnr('$') == 1  " Check if there's only one window
      return
    endif
    wincmd o
    let g:split_opened = 0
  elseif !g:split_opened && line('.') >= g:frozen_line_bottom && line('.') <= g:frozen_line_top + 14 && g:frozen_line != 0
    let target_line = line('.') - g:frozen_line_bottom + g:frozen_line
    execute "normal! mz" | split | set scrollbind | execute 'normal! ' . target_line . 'G' | execute "normal! 8\<C-w>-" | wincmd w
    let g:split_opened = 1
  endif
endfunction

autocmd CursorMoved * call AutoToggleSplit()

nnoremap <leader>fr :call ToggleSplit()<CR>
