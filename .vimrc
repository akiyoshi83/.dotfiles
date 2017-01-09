" vim:set et ts=2 sw=2 sts=2 ft=vim:

" 基本的な見た目
syntax on
set nonumber
set showmode
set ruler
set showcmd
set showmatch
set laststatus=2 "always
set showtabline=2 " always
set statusline=[%{&fileencoding}][\%{&fileformat}]\ %F%m%r%=<%c:%l>

" 検索
set hlsearch
set ignorecase
set smartcase

set smartindent
set expandtab
set ts=4 sw=4 sts=0

" Tab表示
set list
set listchars=tab:>-,trail:<

" 折り畳み有効
set foldmethod=marker
set foldlevelstart=10

" スクロールする時に上下が見えるようにする
set scrolloff=5

"ノーマルモードではセミコロンをコロンに
nnoremap ; :

" バッファ切り替え
set hidden

" クリップボード設定
set clipboard=unnamed " unnamed register = *

" モードラインの検索行数を設定
set modelines=5

" 一時ファイル
set swapfile
set directory=$HOME/.vim/tmp
set backup
set backupdir=$HOME/.vim/tmp
set undofile
set undodir=$HOME/.vim/tmp

" カーソル位置のヘルプを引く
nnoremap <C-h> :<C-u>help<Space><C-r><C-w><CR>

" .vimrc読み書き {{{
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

" デフォルトのファイラー {{{
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

NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
\ }

NeoBundle 'alpaca-tc/vim-endwise'
"NeoBundle 'cakebaker/scss-syntax.vim'
"NeoBundle 'clausreinke/typescript-tools.vim'
NeoBundle 'elzr/vim-json'
NeoBundle 'fatih/vim-go'
"NeoBundle 'hail2u/vim-css3-syntax'
"NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kien/ctrlp.vim'
"NeoBundle 'leafgarland/typescript-vim.git'
"NeoBundle 'othree/html5.vim'
"NeoBundle 'pangloss/vim-javascript'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
"NeoBundle 'slim-template/vim-slim'
NeoBundle 'thinca/vim-quickrun'
"NeoBundle 'vim-ruby/vim-ruby'
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
" }}}


"taglist.vim
"http://www.vim.org/scripts/script.php?script_id=273
if executable('ctags')
    :set tags=tags
endif

" NERDTree
let NERDTreeShowHidden = 1 " 隠しファイルをデフォルトで表示させる
"autocmd VimEnter * execute 'NERDTree' " デフォルトでツリーを表示させる
nnoremap <C-l> :NERDTree<CR>

" quickrun
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \ 'outputter' : 'error',
      \ 'outputter/error/success' : 'buffer',
      \ 'outputter/error/error'   : 'quickfix',
      \ 'outputter/buffer/split'  : ':rightbelow 8sp',
      \ 'outputter/buffer/close_on_empty' : 1,
      \ }

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['go'] }
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']

" golang {{{
" -----------
" go get github.com/nsf/gocode
if isdirectory('$HOME/src/github.com/nsf/gocode/vim')
  exe "set runtimepath+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
  set completeopt=menu,preview
endif
"}}}

" filetype {{{
au BufRead,BufNewFile *.rb set filetype=rb
au BufRead,BufNewFile Gemfile set filetype=rb
au BufRead,BufNewFile *.erb set filetype=rb
au BufRead,BufNewFile *.haml set filetype=rb
au BufRead,BufNewFile *.slim set filetype=rb
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

au BufRead,BufNewFile *.md set filetype=markdown

au BufRead,BufNewFile *.yaml set filetype=yaml
au BufRead,BufNewFile *.yml set filetype=yaml
au FileType yaml setlocal expandtab ts=2 sw=2 fenc=utf-8

au BufRead,BufNewFile *.json set filetype=json
au FileType json setlocal et ts=2 sw=2 sts=0
" }}}

runtime! userautoload/*.vim
