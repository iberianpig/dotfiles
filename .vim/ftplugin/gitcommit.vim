" https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
function! s:select_type() abort
  let line = substitute(getline('.'), '^#\s*', '', 'g')
  let title = printf('%s ', split(line, ' ')[0])

  silent! normal! "_dip
  silent! put! =title
  silent! startinsert!
endfunction

nnoremap <buffer> <CR><CR> :<C-u>call <SID>select_type()<CR>
