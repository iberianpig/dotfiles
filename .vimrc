"http://vimblog.hatenablog.com/entry/vimrc_introduction
" autocmdのリセット
autocmd!
set number         " 行番号を表示する
set cursorline     " カーソル行の背景色を変える
" set cursorcolumn   " カーソル位置のカラムの背景色を変える
" autocmd InsertEnter,InsertLeave * set cursorline!  "redraw!
" autocmd InsertEnter,InsertLeave * set cursorcolumn!
au WinEnter * set cursorline "cursorcolumn
" au WinLeave * set nocursorline "nocursorcolumn

if has("autocmd")
  au InsertEnter * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"I-Beam"\"'
  au InsertLeave * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"Block"\"'
  au VimLeave * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"I-Beam"\"'
  au VimEnter * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"Block"\"'
  au WinLeave * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"I-Beam"\"'
  au WinEnter * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"Block"\"'
  " au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
  " au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
  " au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
  " au VimEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
  " au WinLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
  " au WinEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
endif

set laststatus=2   " ステータス行を常に表示
set cmdheight=2    " メッセージ表示欄を2行確保
set showmatch      " 対応する括弧を強調表示
set helpheight=998 " ヘルプを画面いっぱいに開く
set list           " 不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮,nbsp:%,trail:_ " 不可視文字の表示記号指定
set t_Co=256 "ターミナルで256色利用

" set relativenumber!  "相対行番号表示
" nnoremap sr :<C-u>setlocal relativenumber!<CR>  "相対行番号表示

" Charset, Line ending -----------------
scriptencoding utf-8
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set ffs=unix,dos,mac  " LF, CRLF, CR
if exists('&ambiwidth')
  set ambiwidth=double  " UTF-8の□や○でカーソル位置がずれないようにする
endif
set spelllang+=cjk

"カーソル移動系
set backspace=indent,eol,start "Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,] "行頭行末の左右移動で行をまたぐ
set scrolloff=8                "上下8行の視界を確保
set sidescrolloff=16           " 左右スクロール時の視界を確保
set sidescroll=1               " 左右スクロールは一文字づつ行う
set lazyredraw                 "描画を遅延させる
" set nolazyredraw                 "描画を遅延させない
" set redrawtime=4000             "再描画までの時間(デフォルトは2000)
set ttyfast                    " カーソル移動高速化

if has("autocmd") " 最後のカーソル位置を復元する
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif

"File処理関連
set confirm "保存されていないファイルがあるときは終了前に保存確認
set hidden "保存されていないファイルがあるときでも別のファイルを開くことが出来る
set autoread "外部でファイルに変更がされた場合は読みなおす
set nobackup "ファイル保存時にバックアップファイルを作らない
set noswapfile "ファイル編集中にスワップファイルを作らない
" set updatetime=0 "ファイル編集中にスワップファイルを作らない

"検索関連
set hlsearch "検索文字列をハイライトする
set incsearch "インクリメンタルサーチを行う
set ignorecase "大文字と小文字を区別しない
set smartcase "大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
set wrapscan "最後尾まで検索を終えたら次の検索で先頭に移る
set gdefault "置換の時 g オプションをデフォルトで有効にする

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" "インサートモードで bash 風キーマップ
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-k> <C-o>D<Right>
inoremap <C-u> <C-o>d^
inoremap <C-w> <C-o>db


set nocompatible "vi 互換モードを解除する"

set timeout timeoutlen=1000 ttimeoutlen=75

" " j, k による移動を折り返されたテキストでも自然に振る舞うように変更
" nnoremap j gj
" nnoremap k gk
nnoremap <Up> gk
nnoremap <Down> gj

" vを二回で行末まで選択
vnoremap v $h

" TABにて対応ペアにジャンプ
" nnoremap <Tab> %
" vnoremap <Tab> %

"すべてを選択
nnoremap <Leader><C-A> ggVG

"ビープの設定
"ビープ音すべてを無効にする
set visualbell t_vb=
set noerrorbells "エラーメッセージの表示時にビープを鳴らさない

"コマンドライン設定
" コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full
" コマンドラインの履歴を1000件保存する
set history=1000
set ttyscroll=20
" set ttyscroll=4

" 動作環境との統合
" OSのクリップボードをレジスタ指定無しで Yank, Put 出来るようにする
set clipboard=unnamed,unnamedplus
"screen利用時設定
set ttymouse=xterm2

" マウスの入力を受け付ける
" set mouse=a
" インサートモードから抜けると自動的にIMEをオフにする
set iminsert=0
set imsearch=-1
" ESCでIMEを確実にOFF
" inoremap <ESC> <ESC>:set iminsert=0<CR>
" inoremap <ESC> <ESC>:set iminsert=0<CR>:redraw!<CR>:redraws!<CR>
""Ctrl-Cでインサートモードを抜ける
inoremap <C-c> <ESC>

if has('unix') && !has('gui_running')
  " ESC後にすぐ反映されない対策
  " nmap <silent> <ESC> <ESC>:nohlsearch<CR>:set iminsert=0<CR>:redraw!<CR>:redraws!<CR>
  map <silent> <ESC> :nohlsearch<CR>:set iminsert=0<CR>:redraw!<CR>:redraws!<CR>
endif

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

"tab/indentの設定
set shellslash
set expandtab "タブ入力を複数の空白入力に置き換える
set tabstop=2 "画面上でタブ文字が占める幅
set shiftwidth=2 "自動インデントでずれる幅
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent "改行時に前の行のインデントを継続する
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set indentkeys=!^F,o,O,0<Bar>,0=where "自動インデントを発動させるタイミングを設定する

"折りたたみ
" set foldenable
set foldmethod=syntax
set foldlevelstart=100 "Don't autofold anything

" set foldlevelstart=2

" autocmd InsertEnter * if !exists('w:last_fdm')
"       \| let w:last_fdm=&foldmethod
"       \| setlocal foldmethod=manual
"       \| endif
" autocmd InsertLeave,WinLeave * if exists('w:last_fdm')
"       \| let &l:foldmethod=w:last_fdm
"       \| unlet w:last_fdm
"       \| endif

" 日本語ヘルプを利用する
set helplang=ja,en

".vimrcの編集用
nnoremap <Space>. :<C-u>tabedit $HOME/dotfiles/.vimrc<CR>

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END

if !has('gui_running') && !(has('win32') || has('win64'))
  " .vimrcの再読込時にも色が変化するようにする
  autocmd MyAutoCmd BufWritePost $HOME/dotfiles/.vimrc nested source $HOME/dotfiles/.vimrc
else
  " .vimrcの再読込時にも色が変化するようにする
  autocmd MyAutoCmd BufWritePost $HOME/dotfiles/.vimrc source $HOME/dotfiles/.vimrc |
        \if !has('gui_running') | source $MYGVIMRC
  autocmd MyAutoCmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
endif

"タブの設定
" The prefix key.
nnoremap [tab]   <Nop>
nmap  t [tab]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [tab]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" tc 新しいタブを右に作る
map <silent> [tab]c :tabnew<CR>
" tn 新しいタブを一番右に作る
map <silent> [tab]n :tablast <bar> tabnew<CR>
" " tx タブを閉じる
map <silent> [tab]q :tabclose<CR>
map <silent> [tab]x :tabclose<CR>
map <silent> [tab]b :tabprevious<CR>
map <silent> [tab]f :tabnext<CR>

"シンタックスハイライトの追加
au BufNewFile,BufRead *.json.jbuilder set ft=ruby

" vimにcoffeeファイルタイプを認識させる
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee
" インデントを設定
autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et

" Use vsplit mode
if has("vim_starting") && !has('gui_running') && has('vertsplit')
  function! g:EnableVsplitMode()
    " enable origin mode and left/right margins
    let &t_CS = "y"
    let &t_ti = &t_ti . "\e[?6;69h"
    let &t_te = "\e[?6;69l" . &t_te
    let &t_CV = "\e[%i%p1%d;%p2%ds"
    call writefile([ "\e[?6h\e[?69h" ], "/dev/tty", "a")
  endfunction

  " old vim does not ignore CPR
  map <special> <Esc>[3;9R <Nop>

  " new vim can't handle CPR with direct mapping
  " map <expr> ^[[3;3R g:EnableVsplitMode()
  set t_F9=[3;3R
  map <expr> <t_F9> g:EnableVsplitMode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif

"NeoBundle Scripts-----------------------------
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=/home/iberianpig/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('/home/iberianpig/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimshell.git'
" NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }
" vimprocのインストールとbuild
" " 自動でインストールしてビルド(make)してくれる
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \ 'windows' : 'make -f make_mingw32.mak',
      \ 'cygwin' : 'make -f make_cygwin.mak',
      \ 'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'gmake',
      \ },
      \ }
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'honza/vim-snippets'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'tsukkee/unite-help'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'osyo-manga/unite-quickfix.git'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'rcmdnk/vim-markdown'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'Shougo/vimfiler'
" NeoBundle 'thinca/vim-guicolorscheme'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'kana/vim-submode'
NeoBundle 'tyru/caw.vim'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'glidenote/octoeditor.vim'
NeoBundle 'othree/html5.vim'
" NeoBundle 'tpope/vim-liquid'
" NeoBundle 'mattn/gist-vim'
NeoBundle 'mattn/webapi-vim'
" NeoBundle 'vim-scripts/vim-auto-save'
" NeoBundle 'xolox/vim-session', { 'depends' : 'xolox/vim-misc',}
NeoBundle 'Shougo/unite-outline'
NeoBundle 'ujihisa/unite-locate'
NeoBundle 'sgur/unite-git_grep'
NeoBundle 'ujihisa/quicklearn'
NeoBundle 'thinca/vim-ref'
NeoBundle 'taka84u9/vim-ref-ri'
NeoBundle 'mfumi/ref-dicts-en'
NeoBundle 'tyru/vim-altercmd'
NeoBundle 'ujihisa/neco-look'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'https://github.com/cohama/lexima.vim'
NeoBundle 'ujihisa/unite-font'
NeoBundle 'sgur/vim-gitgutter'
" NeoBundle 'rhysd/migemo-search.vim'
" NeoBundle 'haya14busa/vim-migemo'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'kannokanno/previm'
NeoBundle 'lambdalisue/vim-gista'
NeoBundle 'edsono/vim-matchit'
NeoBundle 'basyura/unite-rails'
NeoBundle 'aurigadl/vim-angularjs'
NeoBundle 'burnettk/vim-angular'
NeoBundle 'mattn/benchvimrc-vim'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'rking/ag.vim'
NeoBundle 'cohama/vim-hier'
NeoBundle 'dannyob/quickfixstatus'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'KazuakiM/vim-qfstatusline'
NeoBundle 'KazuakiM/vim-qfsigns'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'thoughtbot/vim-rspec'
NeoBundle 'vim-scripts/dbext.vim'
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'moznion/github-commit-comment.vim'

" ctags
" NeoBundle 'szw/vim-tags'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'soramugi/auto-ctags.vim'

" ruby
NeoBundleLazy 'supermomonga/neocomplete-rsense.vim', { 'autoload' : {
      \ 'insert' : 1,
      \ 'filetypes': 'ruby',
      \ }}

" javascript
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'othree/javascript-libraries-syntax.vim'
NeoBundle 'maksimr/vim-jsbeautify'
NeoBundle 'mattn/jscomplete-vim'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'clausreinke/typescript-tools'
NeoBundle 'matthewsimo/angular-vim-snippets'
NeoBundle 'marijnh/tern_for_vim' , {
 \ 'build': {
 \   'others': 'npm install'
  \}}

" css
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'groenewege/vim-less'
NeoBundle 'claco/jasmine.vim'
NeoBundle 'vim-scripts/AnsiEsc.vim'
NeoBundle 'elzr/vim-json'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'lilydjwg/colorizer'

" jade
NeoBundle 'digitaltoad/vim-jade'

"colorscheme
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'croaker/mustang-vim'
NeoBundle 'jeffreyiacono/vim-colors-wombat'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'vim-scripts/Zenburn'
NeoBundle 'mrkn/mrkn256.vim'
NeoBundle 'jpo/vim-railscasts-theme'
NeoBundle 'therubymug/vim-pyte'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'chriskempson/vim-tomorrow-theme'

" Required:
call neobundle#end()

" Required:
filetype plugin indent on
syntax on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

" ...
" 読み込んだプラグインの設定
" ...

" set background=light "明るめの背景
set background=dark "暗めの背景
" colorscheme hybrid "set colorscheme
colorscheme Tomorrow-Night "set colorscheme

" lightline {{{
let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntaxcheck', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntaxcheck', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \   'ctrlpmark': 'CtrlPMark',
      \   'currentworkingdir': 'CurrentWorkingDir',
      \   'percent': 'MyPercent',
      \   'lineinfo': 'MyLineInfo',
      \ },
      \ 'component_expand': {
      \   'syntaxcheck': 'qfstatusline#Update',
      \ },
      \ 'component_type': {
      \   'syntaxcheck': 'error',
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' },
      \ 'tabline': {
      \   'left': [ [ 'tabs' ] ],
      \   'right': [ [ 'currentworkingdir' ] ],
      \ },
      \}

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyPercent()
  return &ft =~? 'vimfiler' ? '' : (100 * line('.') / line('$')) . '%'
endfunction

function! MyLineInfo()
  return &ft =~? 'vimfiler\|unite' ? '' : printf("%3d:%-2d", line('.'), col('.'))
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? MyStatusPath() . '/' . fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyStatusPath()
  if exists('b:my_status_path')
    return b:my_status_path
  endif
  let path  = expand("%:p:h")
  let gpath = finddir('.git', path . ';.;')

  if gpath == ''
    let gpath = findfile('Rakefile', path . ';')
  endif

  if gpath == ''
    let b:my_status_path = fnamemodify(path, ':~:h')
    return b:my_status_path
  endif

  if gpath == '.git' || gpath == 'Rakefile'
    let b:my_status_path = fnamemodify(path, ':t')
  else
    let gpath = fnamemodify(gpath, ':h:h') . '/'
    let b:my_status_path = substitute(path, gpath, '', '')
  endif

  return b:my_status_path
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 70 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
      \ 'main': 'CtrlPStatusFunc_1',
      \ 'prog': 'CtrlPStatusFunc_2',
      \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

function! CurrentWorkingDir()
  return fnamemodify(getcwd(),':')
endfunction
"}}}


"quickrun

autocmd FileType quickrun AnsiEsc

let g:quickrun_config = {
      \   "_" : {
      \       "runner" : "vimproc",
      \       "runner/vimproc/updatetime" : 60
      \   },
      \}

" <C-c> で実行を強制終了させる
" quickrun.vim が実行していない場合には <C-c> を呼び出す
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

"watchdogs_checker
let g:quickrun_config = {
      \    'watchdogs_checker/_' : {
      \       'hook/qfstatusline_update/enable_exit':   1,
      \       'hook/unite_quickfix/enable' : 0,
      \       'hook/close_unite_quickfix/enable' : 0,
      \       'hook/close_buffer/enable_exit' : 1,
      \       'hook/close_quickfix/enable_exit' : 1,
      \       'hook/redraw_unite_quickfix/enable_exit' : 0,
      \       'hook/close_unite_quickfix/enable_exit' : 1,
      \       'hook/qfstatusline_update/priority_exit': 4,},}

" "エラー箇所表示のみ
" let g:quickrun_config = {
"       \        'watchdogs_checker/_' : {
"       \        'outputter/quickfix/open_cmd' : "",
"       \        'hook/qfstatusline_update/enable_exit':   1,
"       \        'hook/qfstatusline_update/priority_exit': 4}}


" Ruby で rubocop を使用するように設定
let g:quickrun_config = {
      \   "ruby/watchdogs_checker" : {
      \       "type" : "watchdogs_checker/rubocop"
      \   }
      \}

" coffeeScript で coffeelint を使用するように設定
let g:quickrun_config = {
      \   "coffee/watchdogs_checker" : {
      \       "type" : "watchdogs_checker/coffeelint"
      \   }
      \}

let g:quickrun_config = {
      \   "jade/watchdogs_checker" : {
      \       "type" : "watchdogs_checker/jade"
      \   }
      \}

let g:quickrun_config = {
      \   "javascript/watchdogs_checker" : {
      \       "type" : 'watchdogs_checker/jshint',
      \       "cmdopt" : '--config .jshintrc'
      \   }
      \}
" let g:quickrun_config["javascript/watchdogs_checker"] = {
"       \ "type" : "watchdogs_checker/jshint"
"       \}


let g:quickrun_config = {
      \   "css/watchdogs_checker" : {
      \       "type" : 'watchdogs_checker/csslint',
      \   }
      \}

" シンタックスチェックは<Leader>+wで行う
nnoremap <Leader>w :<C-u>WatchdogsRun<CR>

let g:watchdogs_check_BufWritePost_enables = {
      \   "javascript" : 1,
      \   "sh" : 1,
      \   "sass" : 1,
      \   "scss" : 1
      \}

let g:watchdogs_check_CursorHold_enable = 0


call watchdogs#setup(g:quickrun_config)

" If syntax error, cursor is moved at line setting sign.
let g:qfsigns#AutoJump = 1
" If syntax error, view split and cursor is moved at line setting sign.
let g:qfsigns#AutoJump = 2

let g:Qfstatusline#UpdateCmd = function('lightline#update')
" watchdogs.vim の設定を追加

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

"" {{{vimfiler
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default = 0
" let g:vimfiler_edit_action = 'tabopen'
" Like Textmate icons.
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = '-'
let g:vimfiler_marked_file_icon = '*'
let g:vimfiler_ignore_pattern='\(^\.\|\~$\|\.pyc$\|\.[oad]$\)'
autocmd VimEnter * call s:vimfiler_initialize()
function! s:vimfiler_initialize() "workaround for cancel whitespace
  VimFiler -split -simple -winwidth=40 -direction=topleft -buffer-name=explorer -split -simple -project -toggle -no-quit<CR>
  VimFiler -split -simple -winwidth=40 -direction=topleft -buffer-name=explorer -split -simple -project -toggle -no-quit<CR>
endfunction
" autocmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
nnoremap <C-k><C-f> :VimFiler -project<CR>
inoremap <C-k><C-f> <ESC>:VimFiler -project<CR>
nnoremap <C-k><C-k> :VimFiler -direction=topleft -buffer-name=explorer -split -simple -project -winwidth=40 -toggle -no-quit<CR>
nnoremap <C-k><C-c> :VimFilerBufferDir -direction=topleft -buffer-name=explorer -split -simple -winwidth=40 -toggle -no-quit<CR>

autocmd FileType vimfiler* call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()
  nnoremap <buffer><silent>/ :<C-u>UniteWithBufferDir file<CR>
  nnoremap <silent> <buffer> <expr> <C-t> vimfiler#do_action('tabopen')
endfunction
"" }}}
" neocomplete {{{
let g:neocomplete#enable_at_startup               = 1
let g:neocomplete#auto_completion_start_length    = 4
let g:neocomplete#enable_ignore_case              = 1
let g:neocomplete#enable_smart_case               = 0
let g:neocomplete#enable_camel_case               = 1
let g:neocomplete#use_vimproc                     = 1
let g:neocomplete#sources#buffer#cache_limit_size = 1000000
let g:neocomplete#sources#tags#cache_limit_size   = 30000000
let g:neocomplete#enable_fuzzy_completion         = 1
let g:neocomplete#lock_buffer_name_pattern        = '\*ku\*'
let g:neocomplete#force_overwrite_completefunc=1
"キャッシュディレクトリの場所
"RamDiskをキャッシュディレクトリに設定
if has('macunix')
  let g:neocomplete#data_directory = '/tmp'
else
  let g:neocomplete#data_directory = '/tmp/.neocon'
endif
" Plugin key-mappings.
" inoremap <expr><C-g>     neocomplete#undo_completion()
" inoremap <expr><C-l>     neocomplete#complete_common_string()
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><C-y>  neocomplete#close_popup()
" inoremap <expr><C-e>  neocomplete#cancel_popup()
"for rsense
"" Set $RSENSE_HOME path.
let g:neocomplete#sources#rsense#home_directory = '~/.rbenv/shims/rsense'
let g:rsenseUseOmniFunc = 1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby =  '[^. *\t]\.\w*\|\h\w*::'
" }}}
"
"for turn_vim
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

" "NeoSnippet.vim
let g:neosnippet#enable_snipmate_compatibility = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets, ~/.vim/snippets'
" Plugin key-mappings.
imap <Nul> <C-Space>
imap <C-Space>     <Plug>(neosnippet_expand_or_jump)
smap <C-Space>     <Plug>(neosnippet_expand_or_jump)
xmap <C-Space>     <Plug>(neosnippet_expand_target)

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" neosnippet.vim公式指定をちょっといじる
imap <expr><TAB> neosnippet#jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: "\<TAB>"

" rails
autocmd BufEnter * if exists("b:rails_root") | NeoCompleteSetFileType ruby.rails | endif
autocmd BufEnter * if (expand("%") =~ "_spec\.rb$") || (expand("%") =~ "^spec.*\.rb$") | NeoCompleteSetFileType ruby.rspec | endif

"" switch
nnoremap - :Switch<cr>
"" submode.vim
" http://d.hatena.ne.jp/thinca/20130131/1359567419
" ウィンドウサイズの変更キーを簡易化する
" [C-w],[+]または、[C-w],[-]
call submode#enter_with('winsize', 'n', '', '<C-w>L', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w>H', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>J', '<C-w>-')
call submode#enter_with('winsize', 'n', '', '<C-w>K', '<C-w>+')
call submode#map('winsize', 'n', '', 'L', '<C-w>>')
call submode#map('winsize', 'n', '', 'H', '<C-w><')
call submode#map('winsize', 'n', '', 'J', '<C-w>-')
call submode#map('winsize', 'n', '', 'K', '<C-w>+')

" Shift + 矢印でウィンドウサイズを変更
" map <Left>  <C-w><<CR>
" map <Right> <C-w>><CR>
" map <Up>    <C-w>-<CR>
" map <Down>  <C-w>+<CR>

"" over.vim
" over.vimの起動
nnoremap <silent> ,m :OverCommandLine<CR>%s/
" カーソル下の単語をハイライト付きで置換
nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
" コピーした文字列をハイライト付きで置換
nnoremap subp y:OverCommandLine<CR>%s/<C-r>=substitute(@0, '/', '/', 'g')<CR>//g<Left><Left>

" Unite
" " インサートモードで開始
" let g:unite_enable_start_insert=1
" ヒストリー/ヤンク機能を有効化
let g:unite_source_history_yank_enable =1
" 最近のファイルの個数制限
" let g:unite_source_file_mru_limit = 200
" file_recのキャッシュ
" let g:unite_source_rec_max_cache_files = 50000
" let g:unite_source_rec_min_cache_files = 100

"Like ctrlp.vim settings.
call unite#custom#profile('default', 'context', {
      \   'start_insert': 1,
      \   'direction': 'botright',
      \ })

if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_rec_async_command =
        \ 'ag --follow --nocolor --nogroup -g ""'
endif

call unite#filters#sorter_default#use(['sorter_ftime*'])
call unite#filters#matcher_default#use(['matcher_fuzzy'])
" 画像はキャッシュしない
call unite#custom#source('file_rec/async', 'ignore_pattern', '\(png\|gif\|jpeg\|jpg\)$')
" ファイルはタブで開く
call unite#custom_default_action('file', 'tabopen')
call unite#custom_default_action('directory', 'file')

"prefix keyの設定
nmap <Space> [unite]
""スペースキーとaキーでカレントディレクトリを表示
nnoremap <silent> [unite]a :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
"スペースキーとfキーでバッファと最近開いたファイル一覧を表示
nnoremap <silent> [unite]f :<C-u>Unite<Space> buffer file_mru<CR>
"スペースキーとdキーで最近開いたディレクトリを表示
nnoremap <silent> [unite]d :<C-u>Unite<Space> directory_mru<CR>
"スペースキーとbキーでバッファを表示
nnoremap <silent> [unite]b :<C-u>Unite<Space>buffer<CR>
""スペースキーとrキーでレジストリを表示
" nnoremap <silent> [unite]r :<C-u>Unite<Space> register<CR>
"スペースキーとtキーでtagsを検索
nnoremap <silent> [unite]t :<C-u>Unite<Space>  tag<CR>
""スペースキーとhキーでヒストリ/ヤンクを表示
nnoremap <silent> [unite]h :<C-u>Unite<Space> history/yank<CR>
"スペースキーとoキーでoutline
nnoremap <silent> [unite]o :<C-u>Unite<Space> outline -prompt-direction="top"<CR>
""スペースキーとgキーでgrep
" vnoremap <silent> [unite]/g :Unite grep::-iHRn:<C-R>=escape(@", '\\.*$^[]')<CR><CR>
" grep検索
nnoremap <silent> [unite]g  :<C-u>Unite grep:. -buffer-name=search-buffer <CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> [unite]cg :<C-u>Unite grep:. -buffer-name=search-buffer <CR><C-R><C-W>
" git-grep
nnoremap <silent> [unite]gg  :<C-u>:Unite vcs_grep/git:. -buffer-name=search-buffer <CR>


let g:unite_source_git_grep_max_candidates=200
let g:unite_source_git_grep_required_pattern_length=4

" ignore files
call unite#custom#source('file_rec/async', 'ignore_pattern', '(png\|gif\|jpeg\|jpg)$')

" grep検索結果の再呼出
nnoremap <silent> [unite]r  :<C-u>UniteResume search-buffer <CR>
" " bookmark
" nnoremap <silent> [unite]b :<C-u>Unite bookmark <CR>
" " add to  bookmark
" nnoremap <silent> [unite]ba :<C-u>UniteBookmarkAdd <CR>

""スペースキーとENTERキーでfile_rec:!
" 速度に難ありのため除外中
" nnoremap [unite]<CR> :<C-u>execute
"       \ 'Unite'
"       \ 'buffer'
"       \ 'file_rec/async:!:'.fnameescape(expand('%:p:h'))
"       \ '-default-action=tabopen'<CR>

"unite.vimを開いている間のキーマッピング
autocmd FileType unite* call s:unite_my_settings()
function! s:unite_my_settings()
  " rerwite chache
  nnoremap <C-c> <Plug>(unite_redraw)
  "ESCでuniteを終了
  nmap <buffer> <ESC> <Plug>(unite_exit)
  " nmap <buffer> <ESC><ESC> <Plug>(unite_exit)
  "入力モードのときjjでノーマルモードに移動
  imap <buffer> jj <Plug>(unite_insert_leave)
  "入力モードのときctrl+wでバックスラッシュも削除
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  "ctrl+kでauto-previewモードにする
  nmap <buffer> <C-k> <Plug>(unite_toggle_auto_preview)
  imap <buffer> <C-k> <Plug>(unite_toggle_auto_preview)
  "ctrl+sで縦に分割して開く
  nnoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  inoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  "ctrl+vでに分割して開く
  nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
  inoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
  "ctrl+oでその場所に開く
  nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
  inoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
endfunction

" ctrlp.vim
let g:ctrlp_map = "[unite]<CR>"
" let g:ctrlp_user_command = 'ag %s -l'
let g:ctrlp_user_command = 'ag %s -i --nocolor --column --ignore --nogroup -g ""'
let g:ctrlp_use_migemo = 1
" let g:ctrlp_use_caching = 0
let g:ctrlp_clear_cache_on_exit = 0   " 終了時キャッシュをクリアしない
let g:ctrlp_mruf_max            = 3000 " MRUの最大記録数
let g:ctrlp_open_new_file       = 1   " 新規ファイル作成時にタブで開く
let g:ctrlp_prompt_mappings = {
      \ 'PrtBS()':              ['<c-h>', '<bs>', '<c-]>'],
      \ 'PrtDelete()':          ['<del>'],
      \ 'PrtDeleteWord()':      ['<c-w>'],
      \ 'PrtClear()':           ['<c-u>'],
      \ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
      \ 'PrtSelectMove("k")':   ['<c-p>', '<up>'],
      \ 'PrtHistory(-1)':       ['<c-k>'],
      \ 'PrtHistory(1)':        ['<c-j>'],
      \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
      \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
      \ 'AcceptSelection("t")': ['<c-t>', '<MiddleMouse>'],
      \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
      \ 'ToggleFocus()':        ['<s-tab>'],
      \ 'ToggleRegex()':        ['<c-r>'],
      \ 'ToggleByFname()':      ['<c-d>'],
      \ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
      \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
      \ 'PrtExpandDir()':       ['<tab>'],
      \ 'PrtInsert("w")':       ['<F2>', '<insert>'],
      \ 'PrtInsert("s")':       ['<F3>'],
      \ 'PrtInsert("v")':       ['<F4>'],
      \ 'PrtInsert("+")':       ['<F6>'],
      \ 'PrtCurStart()':        ['<c-a>'],
      \ 'PrtCurEnd()':          ['<c-e>'],
      \ 'PrtCurLeft()':         ['<left>', '<c-^>'],
      \ 'PrtCurRight()':        ['<c-l>', '<right>'],
      \ 'PrtClearCache()':      ['<c-R>'],
      \ 'PrtDeleteMRU()':       ['<F7>'],
      \ 'CreateNewFile()':      ['<c-y>'],
      \ 'MarkToOpen()':         ['<c-z>'],
      \ 'OpenMulti()':          ['<c-o>'],
      \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
      \ }

"Octorpess
let g:octopress_path = '~/octopress'
let g:octopress_comments = 0
let g:octopress_published = 0
let g:octopress_bundle_exec = 1
let g:octopress_prompt_categories = 1
let g:octopress_prompt_tags = 1
let g:octopress_unite = 1
" let g:octopress_auto_open_results = 1
" use unite (default 0)
let g:octopress_unite = 1
" use arbitrary unite option (default is empty)
let g:octopress_unite_option = "-start-insert "
" use arbitrary unite source (default is 'file')
let g:octopress_unite_source = "file"
let g:octopress_qfixgrep = 0
map [unite]on  :OctopressNew<CR>
map [unite]ol  :OctopressList<CR>
map [unite]og  :OctopressGrep<CR>
map [unite]oG  :OctopressGenerate<CR>
map [unite]od  :OctopressDeploy<CR>

" "gist-vim
" let g:gist_detect_filetype = 1
" let g:github_user  = 'iberianpig'
" " Only :w! updates a gist.
" let g:gist_update_on_write = 2

" "vim-ref
" vim-ref のバッファを q で閉じられるようにする
autocmd FileType ref-* nnoremap <buffer> <silent> q :<C-u>close<CR>

" テキストブラウザのインストールが必要
" sudo apt-get install lynx

" 辞書定義
let g:ref_source_webdict_sites = {
      \   'je': {
      \     'url': 'http://eow.alc.co.jp/search?q=%s',
      \   },
      \   'ej': {
      \     'url': 'http://eow.alc.co.jp/search?q=%s',
      \   },
      \ }

" デフォルトサイト
let g:ref_source_webdict_sites.default = 'ej'

" 出力に対するフィルタ
" 最初の数行を削除
function! g:ref_source_webdict_sites.je.filter(output)
  let l:str = substitute(a:output, "       単語帳", "", "g")
  return join(split(str, "\n")[30 :], "\n")
endfunction

function! g:ref_source_webdict_sites.ej.filter(output)
  let l:str = substitute(a:output, "       単語帳", "", "g")
  return join(split(str, "\n")[30 :], "\n")
endfunction

call altercmd#load()
CAlterCommand ej Ref webdict ej
CAlterCommand je Ref webdict je

"gitgutter
let g:gitgutter_diff_args = '-w'
nnoremap <silent> ,gg :<C-u>GitGutterToggle<CR>
nnoremap <silent> ,gh :<C-u>GitGutterLineHighlightsToggle<CR>

"migemosearch
"  if executable('cmigemo')
"   cnoremap <expr><CR> migemosearch#replace_search_word()."\<CR>"
" endif

"previm
augroup PrevimSettings
  autocmd!
  autocmd  BufEnter *.{md,mdwn,mkd,mkdn,mark*} call s:loadPrevimSetting()
augroup END

function! s:loadPrevimSetting()
  let g:previm_enable_realtime = 1
  nmap <Leader>r :PrevimOpen<CR>
endfunction

"gista
let g:gista#github_user = 'iberianpig'
let g:gista#post_private = 1
""unite
nnoremap <silent> [unite]gs :<C-u>Unite<Space> gista<CR>

" for open-browser plugin
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

"indentline
let g:indentLine_faster=1
let g:indentLine_color_term = 239
nmap <Leader>\| :IndentLinesToggle<CR>
let g:indentLine_bufNameExclude = ['help', 'vimfiler', 'ctrlp', 'unite']
let g:indentLine_enabled=0
" nnoremap <Leader>i :<C-u>setlocal cursorcolumn!<CR>

" let g:rspec_command = 'Dispatch RAILS_ENV=test spring rspec --format progress --no-profile {spec}'
" let g:rspec_command = 'Dispatch rspec {spec}'
" let g:rspec_command = "compiler rspec | set makeprg=spring | Make rspec -fd {spec}"
let g:rspec_command = "compiler rspec | set makeprg=spring | Make rspec --color --drb --tty {spec}"
function! s:load_rspec_settings()
  nmap <silent><leader>r :call RunCurrentSpecFile()<CR>
  nmap <silent><leader>n :call RunNearestSpec()<CR>
  nmap <silent><leader>l :call RunLastSpec()<CR>
  nmap <silent><leader>a :call RunAllSpecs()<CR>
endfunction

augroup RSpecSetting
  autocmd!
  autocmd  BufEnter *_spec.rb call s:load_rspec_settings()
augroup END

" function! s:load_rspec_settings()
"   "" rspec.vim {{{
"   let g:RspecBin  ="RAILS_ENV=test bundle exec rspec"
"   let g:RspecOpts ="--drb -c -fd"
"
"   " rspec.vim keymap
"   " nnoremap <Leader>r :RunSpec<CR>
"   " nnoremap <Leader>l :RunSpecLine<CR>
"   " nnoremap <Leader>a :RunSpecs<CR>
"   "" }}}
" endfunction
"
" augroup RSpecSetting
"   autocmd!
"   autocmd BufEnter *_spec.rb call s:load_rspec_settings()
" augroup END


" 常にprojectのroot Dirに移動する
function! ChangeCurrentDirectoryToProjectRoot()
  let root = unite#util#path2project_directory(expand('%'))
  execute 'lcd' root
endfunction
:au BufEnter * :call ChangeCurrentDirectoryToProjectRoot()

"" hilight minimap
" let g:minimap_highlight='Visual'

let g:vim_json_syntax_conceal = 0

" vim-coffee-script
autocmd BufWritePost *.coffee silent make!

" lexima plugin
call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:;]', 'char': '(', 'input': '('})
call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:;]', 'char': '{', 'input': '{'})
call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:;]', 'char': '[', 'input': '['})
call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:;]', 'char': '''', 'input': ''''})
call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:;]', 'char': '"', 'input': '"'})
call lexima#add_rule({'at': '\%#\n\s*)', 'char': ')', 'input': ')', 'delete': ')'})
call lexima#add_rule({'at': '\%#\n\s*}', 'char': '}', 'input': '}', 'delete': '}'})
call lexima#add_rule({'at': '\%#\n\s*]', 'char': ']', 'input': ']', 'delete': ']'})

"caw
"" <C-/> or <C-_> でコメントトグル
nmap <C-_> <Plug>(caw:i:toggle)
vmap <C-_> <Plug>(caw:i:toggle)

" easymotion
let g:EasyMotion_do_mapping = 0 "Disable default mappings
nmap s <Plug>(easymotion-s2)
" set nohlsearch
" map  / <Plug>(easymotion-sn)
" omap / <Plug>(easymotion-tn)
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)
let g:EasyMotion_use_migemo = 1

" vim-trailing-whitespace'
if neobundle#tap('vim-trailing-whitespace')
  " uniteでスペースが表示されるので、設定でOFFにします。
  let g:extra_whitespace_ignored_filetypes = ['unite', 'vimfiler', 'vimfiler:explorer', 'md']
endif

"auto_ctags
" 保存時にtagsファイル作成
let g:auto_ctags = 1
let g:auto_ctags_directory_list = ['.git', '.svn']
set tags+=.git/tags;
