" vim:set et ts=2 sw=2 sts=2 ft=vim:

" set basic path
set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
set runtimepath+=$HOME/dotfiles/.vim/

" 基本的な見た目
" -----------------
syntax on
set number
set showmode
set ruler
set showcmd
set showmatch
set laststatus=2
set statusline=[%{&fileencoding}][\%{&fileformat}]\ %F%m%r%=<%c:%l>

" 検索
" -----------------
set hlsearch
set ignorecase
set smartcase
set smartindent

" TAB
set expandtab
set ts=4 sw=4 sts=0

" Tab表示
set list
set listchars=tab:>-,trail:<

" 折り畳み有効
set foldmethod=marker

" スクロールする時に上下が見えるようにする
set scrolloff=5

"ノーマルモードではセミコロンをコロンに
nnoremap ; :

" バッファ切り替え
set hidden

" クリップボード設定
set clipboard=unnamed

" モードライン有効化
set modelines=5

" .vimrc読み書き {{{
" -----------------
"edit .vimrc
nnoremap <silent> <Space>ev  :<C-u>tabnew $MYVIMRC<CR>
nnoremap <silent> <Space>eg  :<C-u>tabnew $MYGVIMRC<CR>

"reload .vimrc
nnoremap <silent> <Space>rv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR>
nnoremap <silent> <Space>rg :<C-u>source $MYGVIMRC<CR>
"}}}

" 文字コード, 改行コード {{{
set encoding=utf-8
set fileencodings=ucs_bom,utf8,ucs-2le,ucs-2
set fileformats=unix,dos,mac

" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = s:fileencodings_default .','. &fileencodings
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" }}}

" タブページ関連 {{{
" -----------------
nnoremap <silent> <Space>te  :<C-u>tabedit<CR>
nnoremap <silent> <Space>tc  :<C-u>tabclose<CR>
nnoremap <silent> <Space>tf  :<C-u>tabfirst<CR>
nnoremap <silent> <Space>tl  :<C-u>tablast<CR>

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction

let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示
" }}}

" filetype {{{
au BufRead,BufNewFile *.rb set filetype=rb
au FileType rb setlocal et ts=2 sw=2 sts=0

au BufRead,BufNewFile *.js set filetype=javascript
au FileType javascript setlocal et ts=2 sw=2 sts=0

au BufRead,BufNewFile,BufReadPre *.coffee set filetype=coffee
au FileType coffee setlocal et ts=2 sw=2 sts=2

au BufRead,BufNewFile *.html set filetype=html
au FileType html setlocal et ts=2 sw=2 sts=0

au BufRead,BufNewFile *.css set filetype=css
au FileType css setlocal et ts=2 sw=2 sts=0

au BufRead,BufNewFile *.less set filetype=less
au FileType less setlocal et ts=2 sw=2 sts=0

au BufRead,BufNewFile *.scss set filetype=scss
au FileType scss setlocal ts=2 sw=2 sts=0

au BufRead,BufNewFile *.go set filetype=go
au FileType go setlocal noet ts=4 sw=4 sts=0

" YAMLファイル用タブストップ設定
au FileType yaml setlocal expandtab ts=2 sw=2 fenc=utf-8
" }}}

" デフォルトのファイラー {{{
" -----------------
" netrwは常にtree view
let g:netrw_liststyle = 3
" 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
let g:netrw_altv = 1
" 'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
let g:netrw_alto = 1
"}}}

" NeoBundle {{{
"NeoBundle Scripts-----------------------------
if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('$HOME/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'


" My Bundles here:
"
"function! s:meet_neocomplete_requirements()
"    return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
"endfunction
"
"if s:meet_neocomplete_requirements()
"    NeoBundle 'Shougo/neocomplete.vim'
"    NeoBundleFetch 'Shougo/neocomplcache.vim'
"else
"    NeoBundleFetch 'Shougo/neocomplete.vim'
"    NeoBundle 'Shougo/neocomplcache.vim'
"endif
"
"NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/unite.vim'
"NeoBundle 'Shougo/vim-vcs'
"NeoBundle 'Shougo/vimfiler.vim'
"NeoBundle 'Shougo/vimproc.vim'
"NeoBundle 'Shougo/vimshell.vim'
"NeoBundle 'Shougo/vinarise.vim'

NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'honza/vim-snippets'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'othree/html5.vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
NeoBundle 'tpope/vim-surround'
"NeoBundle 'vim-scripts/bufferlist.vim'

if executable('ctags')
    NeoBundle 'vim-scripts/taglist.vim'
endif

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------



""bufferlist.vim
""http://www.vim.org/scripts/script.php?script_id=1325
"nnoremap <C-l> :call BufferList()<CR>


"taglist.vim
"http://www.vim.org/scripts/script.php?script_id=273
if executable('ctags')
    :set tags=tags
endif


"vim-ruby
if has('ruby')
    compiler ruby
endif


"lightline.vim
let g:lightline = {
      \ 'colorscheme': 'solarized_dark',
      \ }


"Open Close Quickfix
let s:quickfixwindow = "close"
function! b:openCloseQuickfix()
    if "open" ==? s:quickfixwindow
        let s:quickfixwindow = "close"
        cclose
    else
        let s:quickfixwindow = "open"
        copen
    endif
endfunction

nmap <silent> <F5> :call b:openCloseQuickfix()<CR>
imap <silent> <F5> <C-o>:call b:openCloseQuickfix()<CR>

" unite.vim {{{
" バッファ一覧
nnoremap <silent> <Space>ub :<C-u>Unite buffer<CR>
nnoremap <silent> <Space>j  :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> <Space>uf :<C-u>Unite file_rec<CR>
nnoremap <silent> <Space>k :<C-u>Unite file_rec<CR>
nnoremap <silent> <Space>f :<C-u>Unite file<CR>
" タブページ一覧
nnoremap <silent> <Space>ut :<C-u>Unite tab<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" }}}

" }}}

" golang {{{
" -----------
" !!! Requrie $GOROOT !!!
if $GOROOT != ""
  if isdirectory(globpath($GOROOT, "/misc/vim"))
    set runtimepath+=$GOROOT/misc/vim
  endif
  " go get github.com/nsf/gocode
  if isdirectory('$GOROOT/src/github.com/nfs/gocode/vim')
    exe "set runtimepath+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
    set completeopt=menu,preview
  endif
endif
"}}}
