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

" 一時ファイル
set swapfile
set directory=$HOME/.vim/tmp
set backup
set backupdir=$HOME/.vim/tmp
set undofile
set undodir=$HOME/.vim/tmp

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
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
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
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-ruby/vim-ruby'
"NeoBundle 'vim-scripts/bufferlist.vim'

" ruby plugins {{{
NeoBundle 'tpope/vim-rails', { 'autoload' : {
      \ 'filetypes' : ['haml', 'ruby', 'eruby'] }}
NeoBundle 'vim-scripts/dbext.vim', { 'autoload' : {
      \ 'filetypes' : ['haml', 'ruby', 'eruby'] }}
NeoBundleLazy 'alpaca-tc/vim-endwise.git', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }}
NeoBundleLazy 'edsono/vim-matchit', { 'autoload' : {
      \ 'filetypes': 'ruby',
      \ 'mappings' : ['nx', '%'] }}
NeoBundleLazy 'basyura/unite-rails', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \   'unite_sources' : [
      \     'rails/bundle', 'rails/bundled_gem', 'rails/config',
      \     'rails/controller', 'rails/db', 'rails/destroy', 'rails/features',
      \     'rails/gem', 'rails/gemfile', 'rails/generate', 'rails/git', 'rails/helper',
      \     'rails/heroku', 'rails/initializer', 'rails/javascript', 'rails/lib', 'rails/log',
      \     'rails/mailer', 'rails/model', 'rails/rake', 'rails/route', 'rails/schema', 'rails/spec',
      \     'rails/stylesheet', 'rails/view'
      \   ]
      \ }}
NeoBundleLazy 'taka84u9/vim-ref-ri', {
      \ 'depends': ['Shougo/unite.vim', 'thinca/vim-ref'],
      \ 'autoload': { 'filetypes': ['haml', 'ruby', 'eruby'] } }
NeoBundleLazy 'alpaca-tc/alpaca_tags', {
      \ 'depends': 'Shougo/vimproc',
      \ 'autoload' : {
      \   'commands': ['AlpacaTagsUpdate', 'AlpacaTagsSet', 'AlpacaTagsBundle']
      \ }}
NeoBundleLazy 'tsukkee/unite-tag', {
      \ 'depends' : ['Shougo/unite.vim'],
      \ 'autoload' : {
      \   'unite_sources' : ['tag', 'tag/file', 'tag/include']
      \ }}
NeoBundle 'scrooloose/syntastic'

" vim-rails {{{
let g:rails_default_file='config/database.yml'
let g:rails_level = 4
let g:rails_mappings=1
let g:rails_modelines=0
" let g:rails_some_option = 1
" let g:rails_statusline = 1
" let g:rails_subversion=0
" let g:rails_syntax = 1
" let g:rails_url='http://localhost:3000'
" let g:rails_ctags_arguments='--languages=-javascript'
" let g:rails_ctags_arguments = ''
function! SetUpRailsSetting()
  nnoremap <buffer><Space>r :R<CR>
  nnoremap <buffer><Space>a :A<CR>
  nnoremap <buffer><Space>m :Rmodel<Space>
  nnoremap <buffer><Space>c :Rcontroller<Space>
  nnoremap <buffer><Space>v :Rview<Space>
  nnoremap <buffer><Space>p :Rpreview<CR>
endfunction

aug MyAutoCmd
  au User Rails call SetUpRailsSetting()
aug END

aug RailsDictSetting
  au!
aug END
" }}}

" Unite-rails.vim {{{
function! UniteRailsSetting()
  nnoremap <buffer><C-H><C-H><C-H>  :<C-U>Unite rails/view<CR>
  nnoremap <buffer><C-H><C-H>       :<C-U>Unite rails/model<CR>
  nnoremap <buffer><C-H>            :<C-U>Unite rails/controller<CR>

  nnoremap <buffer><C-H>c           :<C-U>Unite rails/config<CR>
  nnoremap <buffer><C-H>s           :<C-U>Unite rails/spec<CR>
  nnoremap <buffer><C-H>m           :<C-U>Unite rails/db -input=migrate<CR>
  nnoremap <buffer><C-H>l           :<C-U>Unite rails/lib<CR>
  nnoremap <buffer><expr><C-H>g     ':e '.b:rails_root.'/Gemfile<CR>'
  nnoremap <buffer><expr><C-H>r     ':e '.b:rails_root.'/config/routes.rb<CR>'
  nnoremap <buffer><expr><C-H>se    ':e '.b:rails_root.'/db/seeds.rb<CR>'
  nnoremap <buffer><C-H>ra          :<C-U>Unite rails/rake<CR>
  nnoremap <buffer><C-H>h           :<C-U>Unite rails/heroku<CR>
endfunction
aug MyAutoCmd
  au User Rails call UniteRailsSetting()
aug END
" }}}

" vim-ref {{{
let g:ref_open                    = 'split'
let g:ref_refe_cmd                = expand('~/.vim/ref/ruby-ref2.1.2/refe-2_1_2')

nnoremap rr :<C-U>Unite ref/refe     -default-action=split -input=
nnoremap ri :<C-U>Unite ref/ri       -default-action=split -input=

aug MyAutoCmd
  au FileType ruby,eruby,ruby.rspec nnoremap <silent><buffer>KK :<C-U>Unite -no-start-insert ref/ri   -input=<C-R><C-W><CR>
  au FileType ruby,eruby,ruby.rspec nnoremap <silent><buffer>K  :<C-U>Unite -no-start-insert ref/refe -input=<C-R><C-W><CR>
aug END
" }}}

" endwise.vim {{{
let g:endwise_no_mappings=1
" }}}

" matchit {{{
if !exists('loaded_matchit')
  runtime macros/matchit.vim
endif
" }}}

" switch.vim {{{
function! s:separate_defenition_to_each_filetypes(ft_dictionary) "{{{
  let result = {}

  for [filetypes, value] in items(a:ft_dictionary)
    for ft in split(filetypes, ",")
      if !has_key(result, ft)
        let result[ft] = []
      endif

      call extend(result[ft], copy(value))
    endfor
  endfor

  return result
endfunction"}}}

" ------------------------------------
" switch.vim
" ------------------------------------
nnoremap ! :Switch<CR>
let s:switch_definition = {
      \ '*': [
      \   ['is', 'are']
      \ ],
      \ 'ruby,eruby,haml' : [
      \   ['if', 'unless'],
      \   ['while', 'until'],
      \   ['.blank?', '.present?'],
      \   ['include', 'extend'],
      \   ['class', 'module'],
      \   ['.inject', '.delete_if'],
      \   ['.map', '.map!'],
      \   ['attr_accessor', 'attr_reader', 'attr_writer'],
      \ ],
      \ 'Gemfile,Berksfile' : [
      \   ['=', '<', '<=', '>', '>=', '~>'],
      \ ],
      \ 'ruby.application_template' : [
      \   ['yes?', 'no?'],
      \   ['lib', 'initializer', 'file', 'vendor', 'rakefile'],
      \   ['controller', 'model', 'view', 'migration', 'scaffold'],
      \ ],
      \ 'erb,html,php' : [
      \   { '<!--\([a-zA-Z0-9 /]\+\)--></\(div\|ul\|li\|a\)>' : '</\2><!--\1-->' },
      \ ],
      \ 'rails' : [
      \   [100, ':continue', ':information'],
      \   [101, ':switching_protocols'],
      \   [102, ':processing'],
      \   [200, ':ok', ':success'],
      \   [201, ':created'],
      \   [202, ':accepted'],
      \   [203, ':non_authoritative_information'],
      \   [204, ':no_content'],
      \   [205, ':reset_content'],
      \   [206, ':partial_content'],
      \   [207, ':multi_status'],
      \   [208, ':already_reported'],
      \   [226, ':im_used'],
      \   [300, ':multiple_choices'],
      \   [301, ':moved_permanently'],
      \   [302, ':found'],
      \   [303, ':see_other'],
      \   [304, ':not_modified'],
      \   [305, ':use_proxy'],
      \   [306, ':reserved'],
      \   [307, ':temporary_redirect'],
      \   [308, ':permanent_redirect'],
      \   [400, ':bad_request'],
      \   [401, ':unauthorized'],
      \   [402, ':payment_required'],
      \   [403, ':forbidden'],
      \   [404, ':not_found'],
      \   [405, ':method_not_allowed'],
      \   [406, ':not_acceptable'],
      \   [407, ':proxy_authentication_required'],
      \   [408, ':request_timeout'],
      \   [409, ':conflict'],
      \   [410, ':gone'],
      \   [411, ':length_required'],
      \   [412, ':precondition_failed'],
      \   [413, ':request_entity_too_large'],
      \   [414, ':request_uri_too_long'],
      \   [415, ':unsupported_media_type'],
      \   [416, ':requested_range_not_satisfiable'],
      \   [417, ':expectation_failed'],
      \   [422, ':unprocessable_entity'],
      \   [423, ':precondition_required'],
      \   [424, ':too_many_requests'],
      \   [426, ':request_header_fields_too_large'],
      \   [500, ':internal_server_error'],
      \   [501, ':not_implemented'],
      \   [502, ':bad_gateway'],
      \   [503, ':service_unavailable'],
      \   [504, ':gateway_timeout'],
      \   [505, ':http_version_not_supported'],
      \   [506, ':variant_also_negotiates'],
      \   [507, ':insufficient_storage'],
      \   [508, ':loop_detected'],
      \   [510, ':not_extended'],
      \   [511, ':network_authentication_required'],
      \ ],
      \ 'rspec': [
      \   ['describe', 'context', 'specific', 'example'],
      \   ['before', 'after'],
      \   ['be_true', 'be_false'],
      \   ['get', 'post', 'put', 'delete'],
      \   ['==', 'eql', 'equal'],
      \   { '\.should_not': '\.should' },
      \   ['\.to_not', '\.to'],
      \   { '\([^. ]\+\)\.should\(_not\|\)': 'expect(\1)\.to\2' },
      \   { 'expect(\([^. ]\+\))\.to\(_not\|\)': '\1.should\2' },
      \ ],
      \ 'markdown' : [
      \   ['[ ]', '[x]']
      \ ]
      \ }

let s:switch_definition = s:separate_defenition_to_each_filetypes(s:switch_definition)
function! s:define_switch_mappings() "{{{
  if exists('b:switch_custom_definitions')
    unlet b:switch_custom_definitions
  endif

  let dictionary = []
  for filetype in split(&ft, '\.')
    if has_key(s:switch_definition, filetype)
      let dictionary = extend(dictionary, s:switch_definition[filetype])
    endif
  endfor

  if exists('b:rails_root')
    let dictionary = extend(dictionary, s:switch_definition['rails'])
  endif

  if has_key(s:switch_definition, '*')
    let dictionary = extend(dictionary, s:switch_definition['*'])
  endif

  "if !empty('dictionary')
  "  call alpaca#let_b:('switch_custom_definitions', dictionary)
  "endif
endfunction"}}}

augroup SwitchSetting
  autocmd!
  autocmd Filetype * if !empty(split(&ft, '\.')) | call <SID>define_switch_mappings() | endif
augroup END
" }}}

" }}} ruby plugins

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


" NERDTree
" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1
" デフォルトでツリーを表示させる
"autocmd VimEnter * execute 'NERDTree'
nnoremap <C-l> :NERDTree<CR>


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

" syntastic {{{
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']
" }}}

" alpaca tags {{{
"
" :TagsUpdate
" Git配下のtagsを生成します。
" :TagsBundle
" Gemfileからgemのtagsを生成します。
" :TagsSet
" 生成したtagsを読み込みます。
" :Unite tags
" uniteを使ってtagを操作します
augroup AlpacaTags
  autocmd!
  if exists(':Tags')
    autocmd BufWritePost Gemfile TagsBundle
    autocmd BufEnter * TagsSet
    " 毎回保存と同時更新する場合はコメントを外す
    " autocmd BufWritePost * TagsUpdate
  endif
augroup END
" }}}

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
