function! g:Paste_lync()
  let lines = split(@*, "\n")
  let results = []
  for line in lines
    let text = substitute(line, '‎', '', 'g')
    let text = substitute(text, '\s\+$', '', 'g')
    call add(results, text)
  endfor
  let @0 = join(results, "\n")
  normal! "0p
  let pos = getpos(".")
  call setpos('.', pos)
endfunction
nnoremap <silent> <Space>pl :<C-u>call g:Paste_lync()<CR>

function! g:Paste_chat()
  let lines = split(@*, "\n")
  let results = []
  for line in lines
    let text = substitute(line, '\(.*\) \(\d\d\?:\d\d:\d\d ..\)$', '\2 \1', 'g')
    let text = substitute(text, '\s\+$', '', 'g')
    call add(results, text)
  endfor
  let @0 = join(results, "\n")
  normal! "0p
  let pos = getpos(".")
  call setpos('.', pos)
endfunction
nnoremap <silent> <Space>pc :<C-u>call g:Paste_chat()<CR>
