" vim:set et ts=2 sw=2 sts=2 ft=vim:

if has('win32') || has ('win64')
  set runtimepath+=~/.vim,~/.vim/after
endif

if has('nvim')
  let plugin_path = '~/.local/share/nvim/plugged'
else
  let plugin_path = '~/.vim/plugged'
endif

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

" 字下げ、改行をバックスペースで削除
set backspace=indent,eol,start

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
set clipboard&
set clipboard^=unnamedplus,unnamed

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

" vim-plug
call plug#begin(plugin_path)
Plug 'elzr/vim-json'
Plug 'felixhummel/setcolors.vim'
Plug 'flazz/vim-colorschemes'
Plug 'fuenor/qfixhowm'
Plug 'godlygeek/tabular'
Plug 'kien/ctrlp.vim'
Plug 'kovisoft/slimv'
Plug 'micha/vim-colors-solarized'
Plug 'natebosch/vim-lsc'
Plug 'plasticboy/vim-markdown'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'racer-rust/vim-racer'
Plug 'rking/ag.vim'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
let g:lsp_async_completion = 1
if executable('ctags')
    Plug 'vim-scripts/taglist.vim'
endif
call plug#end()

" カラースキーム
"" 暗めでも見やすいが透過ではない
"colorscheme industry
"colorscheme murphy
"colorscheme torte
"" 暗めでもそこそこ見やすく透過
"colorscheme ron
"set background=dark
"colorscheme solarized
colorscheme BlackSea

" taglist.vim
" http://www.vim.org/scripts/script.php?script_id=273
if executable('ctags')
    :set tags=tags
endif

" NERDTree
let NERDTreeShowHidden = 1 " 隠しファイルをデフォルトで表示させる
"autocmd VimEnter * execute 'NERDTree' " デフォルトでツリーを表示させる
nnoremap <C-l> :NERDTree<CR>

" golang {{{
" -----------
" https://github.com/golang/go/wiki/gopls#vim--neovim
augroup LspGo
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'go-lang',
      \ 'cmd': {server_info->['gopls']},
      \ 'whitelist': ['go'],
      \ })
  autocmd FileType go setlocal omnifunc=lsp#complete
  autocmd FileType go nmap <buffer> gd <plug>(lsp-definition)
  autocmd FileType go nmap <buffer> ,n <plug>(lsp-next-error)
  autocmd FileType go nmap <buffer> ,p <plug>(lsp-previous-error)
augroup END
"}}}

" ctrlp
if executable('ag')
  let g:ctrlp_use_caching=0
  let g:ctrlp_user_command='ag %s -i --nocolor --nogroup -g ""'
endif

" QFixHowm {{{
function! g:Memo_dir()
  let dir = $HOME . "/Documents/memo"
  if $MEMODIR != ""
    let dir = $MEMODIR
  endif
  if !isdirectory(dir)
      call mkdir(dir, "p")
  endif
  return dir
endfunction

function! g:Memo_cd()
  let dir = Memo_dir()
  exe 'cd' dir
  NERDTree
endfunction

nnoremap <silent> <Space>mc  :<C-u>call Memo_cd()<CR>

let QFixHowm_Key = '<Space>'
let QFixHowm_KeyB = ''
let howm_dir = Memo_dir()
let howm_filename = '%Y/%m/%Y-%m-%d-%H%M%S.md'
let QFixHowm_FileType = 'markdown'
let QFixHowm_Title = '#'
let QFixWin_EnableMode = 1
let QFix_UseLocationList = 1
let QFixHowm_SaveTime = -1
"}}}

" slimv
if has("mac")
  let g:slimv_swank_cmd = '!osascript -e "tell application \"Terminal\" to do script \"ros run --load ~/.vim/plugged/slimv/slime/start-swank.lisp\""'
endif
let g:slimv_repl_simple_eval = 0
let g:slimv_repl_split = 2
let g:slimv_repl_split_size = 20

" rust.vim
let g:rustfmt_autosave = 1

" filetype {{{
au BufRead,BufNewFile *.rb set filetype=ruby
au BufRead,BufNewFile Gemfile set filetype=ruby
au BufRead,BufNewFile *.erb set filetype=ruby
au BufRead,BufNewFile *.haml set filetype=ruby
au BufRead,BufNewFile *.slim set filetype=ruby
au FileType ruby setlocal et ts=2 sw=2 sts=0

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

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_rust_checkers = ['cargo']

runtime! userautoload/*.vim
