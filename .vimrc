"http://vimblog.hatenablog.com/entry/vimrc_introduction
" autocmdのリセット

autocmd!
set number         " 行番号を表示する
set cursorline     " カーソル行の背景色を変える
" set cursorcolumn   " カーソル位置のカラムの背景色を変える

augroup set_cursorline
  autocmd!
  autocmd InsertEnter,InsertLeave * set cursorline!  "redraw!
  " autocmd InsertEnter,InsertLeave * set cursorcolumn!
  autocmd WinEnter * set cursorline "cursorcolumn
  " autocmd WinLeave * set nocursorline "nocursorcolumn
augroup END

function! s:EnableChangeCursorShape()
  augroup change_corsor_shape
    autocmd!
    if executable('pantheon-terminal')
      "Pantheon Terminal
      autocmd InsertEnter * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"I-Beam"\"'
      autocmd InsertLeave * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"Block"\"'
      autocmd VimLeave * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"Block"\"'
      autocmd VimEnter * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"Block"\"'
      autocmd WinLeave * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"Block"\"'
      autocmd WinEnter * silent execute '!dconf write /org/pantheon/terminal/settings/cursor-shape "\"Block"\"'
    endif
    "Guake Terminal
    if executable('guake')
      autocmd InsertEnter * silent execute "!gconftool-2 --type int --set /apps/guake/style/cursor_shape 1"
      autocmd InsertLeave * silent execute "!gconftool-2 --type int --set /apps/guake/style/cursor_shape 0"
      autocmd VimLeave * silent execute "!gconftool-2 --type int --set /apps/guake/style/cursor_shape 0"
      autocmd VimEnter * silent execute "!gconftool-2 --type int --set /apps/guake/style/cursor_shape 0"
      autocmd WinLeave * silent execute "!gconftool-2 --type int --set /apps/guake/style/cursor_shape 0"
      autocmd WinEnter * silent execute "!gconftool-2 --type int --set /apps/guake/style/cursor_shape 0"
    endif
    " autocmd InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
    " autocmd InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
    " autocmd VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
    " autocmd VimEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
    " autocmd WinLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
    " autocmd WinEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
  augroup END
endfunction

function! s:DisableChangeCursorShape()
  augroup change_corsor_shape
    autocmd!
  augroup END
endfunction

call s:EnableChangeCursorShape()

set laststatus=2   " ステータス行を常に表示
set cmdheight=2    " メッセージ表示欄を2行確保
set showmatch      " 対応する括弧を強調表示
set matchpairs+=「:」,『:』,（:）,【:】,《:》,〈:〉,［:］,‘:’,“:”
set helpheight=998 " ヘルプを画面いっぱいに開く
set list           " 不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮,nbsp:%,trail:_ " 不可視文字の表示記号指定
set t_Co=256 "ターミナルで256色利用
set completeopt=menuone "補完時にpreviewWindowを開かない
" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
augroup switch_folding_method
  autocmd!
  autocmd InsertEnter *
        \ if !exists('w:last_fdm') |
        \   let w:last_fdm=&foldmethod |
        \   setlocal foldmethod=manual |
        \ endif
  autocmd InsertLeave,WinLeave *
        \ if exists('w:last_fdm') |
        \   let &l:foldmethod=w:last_fdm |
        \   unlet w:last_fdm |
        \ endif
augroup END
  autocmd!
  autocmd BufReadPost * " 最後のカーソル位置を復元する
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif


" Charset, Line ending -----------------
scriptencoding utf-8
set termencoding=utf-8
" set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set ffs=unix,dos,mac  " LF, CRLF, CR
if exists('&ambiwidth')
  set ambiwidth=double  " UTF-8の□や○でカーソル位置がずれないようにする
endif
set spelllang=en,cjk

" カーソル移動系
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ
set scrolloff=4                " 上下8行の視界を確保
set sidescrolloff=16           " 左右スクロール時の視界を確保
set sidescroll=1               " 左右スクロールは一文字づつ行う
set lazyredraw                 " 描画を遅延させる
set redrawtime=400             "再描画までの時間(デフォルトは2000)
set ttyfast                    " カーソル移動高速化

augroup restore_cursor_position
  autocmd!
  autocmd BufReadPost * " 最後のカーソル位置を復元する
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
augroup END

"File処理関連
set confirm "保存されていないファイルがあるときは終了前に保存確認
set hidden "保存されていないファイルがあるときでも別のファイルを開くことが出来る
set nobackup "ファイル保存時にバックアップファイルを作らない
set noswapfile "ファイル編集中にスワップファイルを作らない
set autoread "外部でファイルに変更がされた場合は読みなおす
" File System synchronize
" if has('unix')
" 	set nofsync
" 	set swapsync=
" endif
augroup vimrc-checktime "window移動/一定時間カーソルが停止した場合に強制的に読みなおす
  autocmd!
  set updatetime=500
  autocmd WinEnter * checktime
  autocmd CursorHold * checktime
augroup END


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

" set timeout timeoutlen=1000 ttimeoutlen=75

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

"履歴に保存する各種設定
set viminfo='100,/50,%,<1000,f50,s100,:100,c,h,!


" 動作環境との統合
" OSのクリップボードをレジスタ指定無しで Yank, Put 出来るようにする
set clipboard=unnamed,unnamedplus

"screen利用時設定
" set ttymouse=xterm2

" マウスの入力を受け付ける
" set mouse=a
" インサートモードから抜けると自動的にIMEをオフにする
set iminsert=0
set imsearch=-1
""Ctrl-Cでインサートモードを抜ける
inoremap <C-c> <ESC>

""jjでインサートモードを抜ける
inoremap <silent> jj <ESC>

if has('unix') && !has('gui_running')
  " ESC後にすぐ反映されない対策
  nmap <silent> <ESC><ESC> <ESC>:nohlsearch<CR>:set iminsert=0<CR>:redraw!<CR>:redraws!<CR>
 " map <silent> <ESC> :nohlsearch<CR>:set iminsert=0<CR>:redraw!<CR>:redraws!<CR>
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

" 日本語ヘルプを利用する
set helplang=ja,en

".vimrcの編集用
nnoremap <Space>. :<C-u>tabedit $HOME/dotfiles/.vimrc<CR>

" " Set augroup.
" augroup MyAutoCmd
"   autocmd!
"   " if !has('gui_running') && !(has('win32') || has('win64'))
"     " .vimrcの再読込時にも色が変化するようにする
"     autocmd BufWritePost $HOME/dotfiles/.vimrc nested source $HOME/dotfiles/.vimrc
"   " else
"     " .vimrcの再読込時にも色が変化するようにする
"     " autocmd BufWritePost $HOME/dotfiles/.vimrc source $HOME/dotfiles/.vimrc |
"           " \if !has('gui_running') | source $MYGVIMRC
"     " autocmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
"   " endif
" augroup END

" q: のタイポ抑制
nnoremap q: :q
nnoremap ; :
" remap record macro key from q to Q
nnoremap Q q
nnoremap q <Nop>


"タブの設定
" The prefix key.
" nnoremap [tab]   <Nop>
" nmap  t [tab]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> g'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" tc 新しいタブを右に作る
nnoremap <silent> gc :tabnew<CR>
" tn 新しいタブを一番右に作る
nnoremap <silent> gn :tablast <bar> tabnew<CR>
" " tx タブを閉じる
nnoremap <silent> gq :tabclose<CR>
nnoremap <silent> gx :tabclose<CR>
nnoremap <silent> gb :tabprevious<CR>
nnoremap <silent> gf :tabnext<CR>

augroup add_syntax_hilight
  autocmd!
  "シンタックスハイライトの追加
  autocmd BufNewFile,BufRead,BufReadPre *.json.jbuilder            set ft=ruby
  autocmd BufNewFile,BufRead,BufReadPre *.erb                      set ft=eruby
  autocmd BufNewFile,BufRead,BufReadPre *.scss                     set ft=scss.css
  autocmd BufNewFile,BufRead,BufReadPre *.coffee                   set ft=coffee
  autocmd BufNewFile,BufRead,BufReadPre *.{md,mdwn,mkd,mkdn,mark*} set ft=markdown
augroup END

let g:ruby_path = system('echo $HOME/.rbenv/shims')

" 不要なデフォルトプラグインの停止
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
" let g:loaded_netrw             = 1
" let g:loaded_netrwPlugin       = 1
" let g:loaded_netrwSettings     = 1
" let g:loaded_netrwFileHandlers = 1


"NeoBundle Scripts-----------------------------
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))
call neobundle#load_cache() "キャッシュ書き込み

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
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
NeoBundle 'tpope/vim-repeat'
NeoBundleLazy "Shougo/unite.vim", {
\   'autoload' : {
\       'commands' : [ "Unite" ]
\   }
\}
NeoBundle 'tsukkee/unite-help'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'osyo-manga/unite-quickfix.git'
NeoBundle 'thinca/vim-quickrun'
NeoBundleLazy "tyru/open-browser.vim", {
\   'autoload' : {
\       'functions' : "OpenBrowser",
\       'commands'  : ["OpenBrowser", "OpenBrowserSearch"],
\       'mappings'  : "<Plug>(openbrowser-smart-search)"
\   },
\}
" NeoBundleLazy 'Shougo/vimfiler', {
" \   'depends' : ["Shougo/unite.vim"],
" \   'autoload' : {
" \       'commands' : [ "VimFilerTab", "VimFiler", "VimFilerExplorer" ]
" \   }
" \}
NeoBundle 'ryanoasis/vim-devicons'
NeoBundle 'thinca/vim-guicolorscheme'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'kana/vim-submode'
NeoBundle 'tyru/caw.vim'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'glidenote/octoeditor.vim'
" NeoBundle 'tpope/vim-liquid'
" NeoBundle 'mattn/gist-vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'ujihisa/unite-locate'
NeoBundle 'lambdalisue/unite-grep-vcs'
NeoBundle 'ujihisa/quicklearn'
NeoBundle 'thinca/vim-ref'
NeoBundle 'taka84u9/vim-ref-ri'
NeoBundle 'mfumi/ref-dicts-en'
NeoBundle 'tyru/vim-altercmd'
NeoBundle 'ujihisa/neco-look'
NeoBundle 'cohama/lexima.vim'
NeoBundle 'ujihisa/unite-font'
NeoBundle 'sgur/vim-gitgutter'
" NeoBundle 'rhysd/migemo-search.vim'
NeoBundle 'haya14busa/vim-migemo'
NeoBundle 'justinmk/vim-sneak'
NeoBundle 'kannokanno/previm'
NeoBundle 'edsono/vim-matchit'
NeoBundle 'mattn/benchvimrc-vim'
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
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'Chiel92/vim-autoformat'
NeoBundle 'itchyny/thumbnail.vim'
NeoBundle 'wakatime/vim-wakatime'
NeoBundle 'LeafCage/yankround.vim'
NeoBundle 'Shougo/neco-syntax'
NeoBundle 'textobj-user'
NeoBundle 'vim-scripts/vim-auto-save'
NeoBundle 'rhysd/clever-f.vim'
NeoBundleLazy 'deton/jasentence.vim', {  "autoload" : {"filetypes" : ["markdown"]} }
NeoBundle 'kana/vim-operator-user'
NeoBundle 'rhysd/vim-operator-surround'
NeoBundle 'glidenote/memolist.vim'

"session管理
NeoBundle 'tpope/vim-obsession'

" git
NeoBundle 'cohama/agit.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'moznion/github-commit-comment.vim'
NeoBundle 'lambdalisue/vim-unified-diff'
NeoBundle 'vim-scripts/diffchar.vim'
NeoBundle 'lambdalisue/vim-gista'
NeoBundle 'lambdalisue/vim-gista-unite'
NeoBundle 'Kocha/vim-unite-tig'

" Markdown syntax
NeoBundleLazy "godlygeek/tabular", {  "autoload" : {"filetypes" : ["markdown"]} }
NeoBundleLazy "rcmdnk/vim-markdown", {  "autoload" : {"filetypes" : ["markdown"]} }

" ctags
" NeoBundle 'szw/vim-tags'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'soramugi/auto-ctags.vim'

" rubyでのみvim-rubyを読み込む
NeoBundleLazy 'vim-ruby/vim-ruby', {  "autoload" : {"filetypes" : ["ruby"]} }
NeoBundleLazy 'pocke/dicts', { "autoload" : { "filetypes" : ["ruby"] }  }
NeoBundleLazy 'osyo-manga/vim-monster', { "autoload" : { "filetypes" : ["ruby"] }  }
NeoBundleLazy 'tpope/vim-bundler', { "autoload" : { "filetypes" : ["ruby"] }  }
NeoBundleLazy 'todesking/ruby_hl_lvar.vim', { "autoload" : { "filetypes" : ["ruby"] }  }

"rails
NeoBundle 'basyura/unite-rails'
NeoBundle 'tpope/vim-rails'

" perl
NeoBundleLazy 'hotchpotch/perldoc-vim', { "autoload" : { "filetypes" : ["perl"] } }

NeoBundleLazy 'vim-perl/vim-perl', { "autoload" : { "filetypes" : ["perl"] } }


NeoBundleLazy 'vim-scripts/php.vim-html-enhanced', { "autoload" : { "filetypes" : ["php"] } }

" html
NeoBundle 'othree/html5.vim', { "autoload" : { "filetypes" : ["html"] } }


" javascript
NeoBundle     'elzr/vim-json'
NeoBundleLazy 'pangloss/vim-javascript', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'othree/javascript-libraries-syntax.vim', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'maksimr/vim-jsbeautify', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'mattn/jscomplete-vim', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'leafgarland/typescript-vim', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'clausreinke/typescript-tools', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'matthewsimo/angular-vim-snippets', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'aurigadl/vim-angularjs', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'burnettk/vim-angular', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'marijnh/tern_for_vim' , {
      \       "autoload": { "filetypes" : ["javascript"] },
      \       'build':    {
      \       'others': 'npm install'
      \}}
NeoBundleLazy 'mxw/vim-jsx', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'Quramy/tsuquyomi', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {'autoload':{'filetypes':['javascript']}}
NeoBundleLazy 'claco/jasmine.vim', {'autoload':{'filetypes':['javascript']}}

NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':['coffee']}}

" css
NeoBundle 'lilydjwg/colorizer'
NeoBundleLazy 'JulesWang/css.vim', {'autoload':{'filetypes':['css']}}
NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload':{'filetypes':['scss','css']}}
NeoBundleLazy 'csscomb/vim-csscomb', {'autoload':{'filetypes':['scss', 'css']}}
NeoBundleLazy 'cakebaker/scss-syntax.vim', {'autoload':{'filetypes':['scss']}}
NeoBundleLazy 'pasela/unite-webcolorname', {'autoload':{'filetypes':['scss', 'css', 'html']}}

" jade
NeoBundle 'digitaltoad/vim-jade', {'autoload':{'filetypes':['jade']}}

" log
NeoBundle 'vim-scripts/AnsiEsc.vim'

"colorscheme
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'croaker/mustang-vim'
NeoBundle 'jeffreyiacono/vim-colors-wombat'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'vim-scripts/Zenburn'
NeoBundle 'mrkn/mrkn256.vim'
NeoBundle 'jpo/vim-railscasts-theme'
NeoBundle 'therubymug/vim-pyte'
" NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'scwood/vim-hybrid'
NeoBundle 'chriskempson/vim-tomorrow-theme'
NeoBundle 'morhetz/gruvbox'
NeoBundle '29decibel/codeschool-vim-theme'
NeoBundle 'tomasr/molokai'
NeoBundle 'vim-scripts/twilight'

" TweetVim
NeoBundle 'basyura/TweetVim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'basyura/bitly.vim'
NeoBundle 'Shougo/unite.vim'

" Required:
NeoBundleSaveCache
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

colorscheme hybrid

" アンダーラインを引く(color terminal)
" highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" lightline {{{
" available colorscheme:
" wombat, solarized, powerline, jellybeans, Tomorrow,
" Tomorrow_Night, Tomorrow_Night_Blue, Tomorrow_Night_Eighties,
" PaperColor, seoul256, landscape and 16color
let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \ },
      \ 'inactive': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntaxcheck', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function':  {
      \   'filename':          'MyFilename',
      \   'fileformat':        'MyFileformat',
      \   'filetype':          'MyFiletype',
      \   'fileencoding':      'MyFileencoding',
      \   'mode':              'MyMode',
      \   'ctrlpmark':         'CtrlPMark',
      \   'currentworkingdir': 'CurrentWorkingDir',
      \   'percent':           'MyPercent',
      \   'lineinfo':          'MyLineInfo',
      \ },
      \ 'component_expand':    {
      \   'syntaxcheck':       'qfstatusline#Update',
      \ },
      \ 'component_type':      {
      \   'syntaxcheck':       'error',
      \ },
      \ 'tabline':             {
      \   'left':              [ [ 'tabs' ] ],
      \   'right':             [ [ 'currentworkingdir' ] ],
      \ },
      \}

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyPercent()
  return &ft =~? 'vimfiler' ? '' : (100 * line('.') / line('$')) . '%'
endfunction

function! MyLineInfo()
  return &ft =~? 'vimfiler\|unite' ? '' : printf('%3d:%-2d', line('.'), col('.'))
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname  == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft   == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft   == 'unite' ? unite#get_status_string() :
        \ &ft   == 'vimshell' ? vimshell#get_status_string() :
        \ (''   != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (''   != fname ? MyStatusPath() . '/' . fname : '[No Name]') .
        \ (''   != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyStatusPath()
  if exists('b:my_status_path')
    return b:my_status_path
  endif
  let path  = expand('%:p:h')
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
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname  == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft   == 'unite' ? 'Unite' :
        \ &ft   == 'vimfiler' ? 'VimFiler' :
        \ &ft   == 'vimshell' ? 'VimShell' :
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
  let g:lightline.ctrlp_prev  = a:prev
  let g:lightline.ctrlp_item  = a:item
  let g:lightline.ctrlp_next  = a:next
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

augroup ansiesc
  autocmd!
  autocmd FileType quickrun AnsiEsc
augroup END

" シンタックスチェックは<Leader>+wで行う
nnoremap <Leader>w :<C-u>WatchdogsRun<CR>

" let g:watchdogs_check_BufWritePost_enables = {
"       \   'sh':         1,
"       \   'sass':       1,
"       \   'scss':       1
"       \}
"       " \   "javascript": 1,
"       " \   "ruby": 1,

let g:watchdogs_check_CursorHold_enable = 0
let g:watchdogs_check_BufWritePost_enable = 0

" <C-c> で実行を強制終了させる
" quickrun.vim が実行していない場合には <C-c> を呼び出す
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

"watchdogs_checker
let g:quickrun_config = {
      \   '_' : {
      \       'hook/close_quickfix/enable_exit' : 1,
      \       'hook/close_buffer/enable_failure' : 1,
      \       'hook/close_buffer/enable_empty_data' : 1,
      \       'outputter' : 'multi:buffer:quickfix',
      \       'outputter/buffer/split' : ':botright 8sp',
      \       'runner' : 'vimproc',
      \       'runner/vimproc/updatetime' : 40,
      \   },
      \   'watchdogs_checker/_' : {
      \       'outputter/quickfix/open_cmd' : '',
      \       'hook/qfsigns_update/enable_exit' : 1,
      \       'hook/back_window/enable_exit' : 1,
      \       'hook/back_window/priority_exit' : 100,
      \   },
      \}
let g:quickrun_config['ruby/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/rubocop',
      \       'cmdopt' : '-S -a -D'
      \   }
let g:quickrun_config['ruby.rails/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/rubocop',
      \       'cmdopt' : '-R -S -a -D'
      \   }
let g:quickrun_config['ruby.rspec/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/rubocop',
      \       "cmdopt" : "-R -S -a -D"
      \   }
let g:quickrun_config['coffee/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/coffeelint'
      \   }
let g:quickrun_config['jade/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/jade'
      \   }
let g:quickrun_config['css/watchdogs_checker'] = {
      \       'type': "watchdogs_checker/csslint"
      \   }
let g:quickrun_config['javascript/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/eslint',
      \       'cmdopt' : "--fix"
      \  }
let g:quickrun_config['javascript.jsx/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/eslint',
      \       'cmdopt' : '--fix'
      \  }
let g:quickrun_config['markdown/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/textlint',
      \  }
let g:quickrun_config['sh/watchdogs_checker'] = {
      \       'command' : 'shellcheck', 'cmdopt' : '-f gcc',
      \       'type': 'watchdogs_checker/shellcheck'
      \  }

" vintコマンドが存在するときだけチェックを行うようにします
let g:quickrun_config['vim/watchdogs_checker'] = {
      \     'type': executable('vint') ? 'watchdogs_checker/vint' : '',
      \     'command'   : 'vint',
      \     'exec'      : '%c %o %s:p' ,
      \   }
" " If syntax error, cursor is moved at line setting sign.
"let g:qfsigns#AutoJump = 1

" If syntax error, view split and cursor is moved at line setting sign.
"let g:qfsigns#AutoJump = 2

let g:Qfstatusline#UpdateCmd = function('lightline#update')
" watchdogs.vim の設定を追加
call watchdogs#setup(g:quickrun_config)

let g:unite_force_overwrite_statusline    = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" neocomplete {{{
let g:neocomplete#enable_at_startup               = 1
let g:neocomplete#auto_completion_start_length    = 2
let g:neocomplete#enable_ignore_case              = 1
" let g:neocomplete#enable_smart_case               = 1
let g:neocomplete#enable_cursor_hold_i            = 1
let g:neocomplete#enable_camel_case               = 1
let g:neocomplete#enable_fuzzy_completion         = 0
let g:neocomplete#use_vimproc                     = 1
let g:neocomplete#lock_buffer_name_pattern        = '\*ku\*'

" vim-monster
let g:monster#completion#rcodetools#backend = "async_rct_complete"
let g:neocomplete#force_omni_input_patterns      = {}
let g:neocomplete#sources#omni#input_patterns = {
      \   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
      \   "rails" : '[^. *\t]\.\w*\|\h\w*::',
      \   "rspec" : '[^. *\t]\.\w*\|\h\w*::',
      \   "eruby" : '[^. *\t]\.\w*\|\h\w*::',
      \   "ruby.rails" : '[^. *\t]\.\w*\|\h\w*::',
      \   "ruby.rspec" : '[^. *\t]\.\w*\|\h\w*::',
      \   "eruby.html" : '[^. *\t]\.\w*\|\h\w*::'
      \}

let g:neocomplete#sources#dictionary#dictionaries = {
\   'ruby': $HOME . '/.vim/bundle/dicts/ruby.dict',
\ }

"for turn_vim
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

" "NeoSnippet.vim
let g:neosnippet#enable_snipmate_compatibility = 1
" remove ${x} marker when switching normal mode
let g:neosnippet#enable_auto_clear_markers = 0
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
" imap <expr><TAB> neosnippet#jumpable() ?
"       \ "\<Plug>(neosnippet_expand_or_jump)"
"       \: pumvisible() ? "\<C-n>" : "\<TAB>"
" smap <expr><TAB> neosnippet#jumpable() ?
"       \ "\<Plug>(neosnippet_expand_or_jump)"
"       \: "\<TAB>"

" rails
"   autocmd!
"   autocmd BufEnter * if exists("b:rails_root") | NeoCompleteSetFileType ruby.rails | endif
"   autocmd BufEnter * if (expand("%") =~ "_spec\.rb$") || (expand("%") =~ "^spec.*\.rb$") | NeoCompleteSetFileType ruby.rspec | endif
" augroup END
let g:neosnippet#snippets_directory = $HOME . '/.vim/snippets'

" enable ruby & rails snippet only rails file
function! s:RailsSnippet()
  if exists("b:rails_root") && (&filetype == "ruby")
    set ft=ruby.rails
  endif
endfunction

function! s:RSpecSnippet()
  if (expand("%") =~ "_spec\.rb$") || (expand("%") =~ "^spec.*\.rb$")
    set ft=ruby.rspec
  endif
endfunction

augroup rails_snnipet
  autocmd!
  au BufEnter * call s:RailsSnippet()
  au BufEnter * call s:RSpecSnippet()
augroup END

" neco-lookの変換対象にする
if !exists('g:neocomplete#text_mode_filetypes')
    let g:neocomplete#text_mode_filetypes = {}
endif
let g:neocomplete#text_mode_filetypes = {
            \ 'rst': 1,
            \ 'markdown': 1,
            \ 'gitrebase': 1,
            \ 'gitcommit': 1,
            \ 'vcs-commit': 1,
            \ 'hybrid': 1,
            \ 'text': 1,
            \ 'help': 1,
            \ 'tex': 1,
            \ }

"}}}

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
call submode#map('winsize',        'n', '', 'L', '<C-w>>')
call submode#map('winsize',        'n', '', 'H', '<C-w><')
call submode#map('winsize',        'n', '', 'J', '<C-w>-')
call submode#map('winsize',        'n', '', 'K', '<C-w>+')

"" over.vim
" over.vimの起動
nnoremap <silent> <C-s> :OverCommandLine<CR>%s/
vnoremap <silent> <C-s> :OverCommandLine<CR>%s/<C-r><C-w>/
" カーソル下の単語をハイライト付きで置換
nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//<Left>
" コピーした文字列をハイライト付きで置換
nnoremap subp y:OverCommandLine<CR>%s/<C-r>=substitute(@0, '/', '/', 'g')<CR>//<Left>

cnoreabb <silent><expr>s getcmdtype()==':' && getcmdline()=~'^s' ? 'OverCommandLine<CR><C-u>%s/<C-r>=get([], getchar(0), '')<CR>' : 's'

"" {{{Unite
" " インサートモードで開始
let g:unite_enable_start_insert=1
" 最近のファイルの個数制限
let g:unite_source_file_mru_limit = 1000
let g:unite_source_file_mru_filename_format = ''
" file_recのキャッシュ
let g:unite_source_rec_max_cache_files = 50000
" let g:unite_source_rec_min_cache_files = 100

let g:webdevicons_enable_unite = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

"Like ctrlp.vim settings.
call unite#custom#profile('default', 'context', {
      \   'direction': 'botright',
      \   'no_cursor_line': 'true'
      \ })

if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
        \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'' ' .
        \ '--ignore ''**/*.pyc'''
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_rec_async_command = [ 'ag', '--follow', '--nocolor', '--nogroup', '-g']
endif
call unite#filters#sorter_default#use(['sorter_ftime*'])
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source('file_rec, file_rec/git, grep/git, buffer, file', 'sorters', 'sorter_selecta')
" 画像はキャッシュしない
" call unite#custom#source('grep/git', 'ignore_pattern', '\.png\|.gif\|.jpeg\|.jpg\')
" call unite#custom#source('source/buffer:?', 'ignore_pattern', '\.png\|.gif\|.jpeg\|.jpg\')
" call unite#custom#source('file_rec/async', 'ignore_pattern', '\.png\|.gif\|.jpeg\|.jpg\')

set wildignore=*.o,*.obj,*.la,*.lo,*.so,*.pyc,*.pyo,*.jpg,*.jpeg,*.png,*.gif,*vimfiler
call unite#custom#source('file_rec/git, grep/git, buffer, file_rec/async', 'ignore_globs',
      \ split(&wildignore, ','))

" ファイルはタブで開く
" call unite#custom_default_action('file', 'tabopen')
call unite#custom_default_action('directory', 'file')

augroup unite_global_keymap
  autocmd!
  autocmd BufEnter * :call s:unite_keymap()
augroup END
"prefix keyの設定
function! s:unite_keymap()
  nnoremap [unite] <Nop>
  vmap <Space> <Nop>
  vmap <Space> [unite]
  nmap <Space> [unite]

  nnoremap <silent> [unite]i :<C-u>Unite<Space>
  ""スペースキーとaキーでカレントディレクトリを表示
  nnoremap <silent> [unite]a :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
  "スペースキーとmキーでプロジェクト内で最近開いたファイル一覧を表示
  nnoremap <silent> [unite]m :<C-u>UniteWithProjectDir<Space>file_mru<CR>
  "スペースキーとMキーで最近開いたファイル一覧を表示
  nnoremap <silent> [unite]M :<C-u>Unite<Space>file_mru<CR>
  "スペースキーとdキーで最近開いたディレクトリを表示
  nnoremap <silent> [unite]d :<C-u>Unite<Space> directory_mru<CR>
  "スペースキーとbキーでバッファを表示
  nnoremap <silent> [unite]b :<C-u>Unite<Space>buffer<CR>
  " nnoremap <silent> [unite]b :<C-u>Thumbnail<Space>-exclude=vimfiler <CR>

  " "スペースキーとtキーでtagsを検索
  vnoremap <silent> [unite]] :<C-u>UniteWithCursorWord -immediately tag:<C-r><C-W><CR>
  nnoremap <silent> [unite]] :<C-u>UniteWithCursorWord -immediately tag:<C-r><C-W><CR>
  autocmd BufEnter *
        \   if empty(&buftype)
        \|      nnoremap <buffer> [unite]t :<C-u>Unite jump<CR>
        \|  endif

  ""tweet vimのアカウントを切り替え
  nnoremap <silent> [unite]s :<C-u>Unite<space> tweetvim/account<CR>

  ""スペースキーとyキーでヒストリ/ヤンクを表示
  nnoremap <silent> [unite]y :<C-u>Unite<Space> yankround<CR>
  ""スペースキーとhキーで:helpを検索
  nnoremap <silent> [unite]h :<C-u>Unite<Space> help -buffer-name=search-buffer<CR>
  "スペースキーとoキーでoutline
  nnoremap <silent> [unite]o :<C-u>Unite<Space> outline -prompt-direction="top"<CR>
  "unite-quickfixを呼び出し
  " multi-line を切る
  let g:unite_quickfix_is_multiline=0
  call unite#custom_source('quickfix', 'converters', 'converter_quickfix_highlight')
  call unite#custom_source('location_list', 'converters', 'converter_quickfix_highlight')
  nnoremap <silent> [unite]q :<C-u>Unite<Space> -no-quit -wrap quickfix<CR>
  ""スペースキーとgキーでgrep
  " vnoremap <silent> [unite]/g :Unite grep::-iHRn:<C-R>=escape(@", '\\.*$^[]')<CR><CR>
  " grep検索
  nnoremap <silent> [unite]g  :<C-u>UniteWithProjectDir grep:. -buffer-name=search-buffer <CR>
  " カーソル位置の単語をgrep検索
  nnoremap <silent> [unite]cg :<C-u>UniteWithProjectDir grep:. -buffer-name=search-buffer <CR><C-R><C-W>
  " git-grep
  nnoremap <silent> [unite]gg  :<C-u>:Unite grep/git:. -buffer-name=search-buffer <CR>

  " grep検索結果の再呼出
  nnoremap <silent> [unite]r  :<C-u>UniteResume search-buffer <CR>
  " " bookmark
  nnoremap <silent> [unite]B :<C-u>Unite bookmark -default-action=vimfiler <CR>
  " add to  bookmark
  " nnoremap <silent> [unite]ba :<C-u>UniteBookmarkAdd <CR>

  ""スペースキーとENTERキーでfile_rec:!
  " nnoremap <silent> [unite]<CR> :<C-u>execute
  "       \ 'Unite'
  "       \ 'file_rec/async:!:'.fnameescape(expand('%:p:h'))
  "       \ '-default-action=tabopen'<CR>

  nnoremap <silent> [unite]<CR> :<C-u>Unite file_rec/git -buffer-name=search-buffer <CR>

  ""unite-rails
  noremap <silent> [unite]ec :<C-u>Unite rails/controller<CR>
  noremap <silent> [unite]em :<C-u>Unite rails/model<CR>
  noremap <silent> [unite]ev :<C-u>Unite rails/view<CR>
  noremap <silent> [unite]eh :<C-u>Unite rails/helper<CR>
  noremap <silent> [unite]es :<C-u>Unite rails/stylesheet<CR>
  noremap <silent> [unite]ej :<C-u>Unite rails/javascript<CR>
  noremap <silent> [unite]er :<C-u>Unite rails/route<CR>
  noremap <silent> [unite]eg :<C-u>Unite rails/gemfile<CR>
  noremap <silent> [unite]et :<C-u>Unite rails/spec<CR>
  noremap <silent> [unite]el :<C-u>Unite rails/log<CR>
  noremap <silent> [unite]ed :<C-u>Unite rails/db<CR>
endfunction
"unite.vimを開いている間のキーマッピング
augroup unite_local_keymap
  autocmd!
  autocmd FileType unite* call s:unite_my_settings()
augroup END
function! s:unite_my_settings()
  " rerwite chache
  nnoremap <C-c> <Plug>(unite_redraw)
  "ESCでuniteを終了
  nmap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> <ESC><ESC> <Plug>(unite_exit)
  "入力モードのときjjでノーマルモードに移動
  " imap <buffer> jj <Plug>(unite_insert_leave)
  " normal modeでも基本の挙動は一致させる
  nmap <buffer> <C-n> j
  nmap <buffer> <C-p> k
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
"" }}}

"" {{{vimfiler
" let g:vimfiler_as_default_explorer  = 1
" let g:webdevicons_enable_vimfiler   = 1
" let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
" " set guifont=M+\ 1m\ regular\ Nerd\ Font\ Complete\ 10
" let g:vimfiler_safe_mode_by_default = 0
" " let g:vimfiler_edit_action = 'tabopen'
" " Like Textmate icons.
" let g:vimfiler_tree_leaf_icon       = ' '
" let g:vimfiler_tree_opened_icon     = '▾'
" let g:vimfiler_tree_closed_icon     = '▸'
" let g:vimfiler_file_icon            = '-'
" let g:vimfiler_marked_file_icon     = '*'
" let g:vimfiler_ignore_pattern       = '\(^\.\|\~$\|\.pyc$\|\.[oad]$\)'
" let g:vimfiler_time_format = '%m-%d-%y %H:%M:%S'
" autocmd VimEnter * call s:vimfiler_initialize()
" function! s:vimfiler_initialize() "workaround for cancel whitespace
"   VimFiler -split -simple -winwidth=40 -direction=topleft -buffer-name=explorer -split -simple -project -toggle -no-quit<CR>
"   VimFiler -split -simple -winwidth=40 -direction=topleft -buffer-name=explorer -split -simple -project -toggle -no-quit<CR>
" endfunction
"
" autocmd BufEnter * if bufname("") !~ "*vimfiler" | call s:vimfiler_keymap() | endif
" function! s:vimfiler_keymap()
"   nmap <Space> [unite]
"   nnoremap [unite]f :VimFiler -buffer-name=explorer -project -force-hide -split -winwidth=40 -direction=topleft -simple -toggle<CR>
"   nnoremap [unite]c :VimFilerBufferDir -direction=topleft -buffer-name=explorer -force-hide -split -winwidth=40 -direction=topleft -simple -toggle<CR>
"   " nnoremap <C-k><C-f> :VimFiler -project<CR>
"   " inoremap <C-k><C-f> <ESC>:VimFiler -project<CR>
"   " nnoremap <C-k><C-k> :VimFiler -direction=topleft -buffer-name=explorer -split -simple -project -winwidth=40 -toggle -no-quit<CR>
"   " nnoremap <C-k><C-c> :VimFilerBufferDir -direction=topleft -buffer-name=explorer -split -simple -winwidth=40 -toggle -no-quit<CR>
" endfunction
"
" augroup local_vimfiler_keymap
"   autocmd FileType vimfiler* call s:vimfiler_my_settings()
" augroup END
" function! s:vimfiler_my_settings()
"   " nnoremap <buffer><silent>/ :<C-u>UniteWithBufferDir file<CR>
"   " nmap <buffer><silent>/ <Plug>(vimfiler_grep)
"   nunmap <buffer><Space>
"   " nunmap g]
"   nmap  <buffer><silent> <expr> <C-t> vimfiler#do_action('tabopen')
"   vmap  <buffer><silent> <expr> <C-t> vimfiler#do_action('tabopen')
"   nmap  <buffer><silent>+ <Plug>(vimfiler_expand_tree)
"   nmap  <buffer><silent>* <Plug>(vimfiler_toggle_mark_current_line)
"   vmap  <buffer><silent>* <Plug>(vimfiler_toggle_mark_current_line)
"   nmap  <buffer><ESC> <Plug>(vimfiler_hide)
"   nmap  <buffer><C-o> <Plug>(vimfiler_edit_file)
"   nmap  <buffer><CR> <Plug>(vimfiler_split_edit_file)
"   call  s:unite_keymap()
" endfunction
"" }}}

let g:vim_markdown_folding_disabled=1

let g:vim_markdown_frontmatter=1

"Octorpess
let g:octopress_path = '~/octopress'
let g:octopress_comments = 1
let g:octopress_published = 0
let g:octopress_bundle_exec = 1
let g:octopress_prompt_categories = 1
let g:octopress_unite = 1
" let g:octopress_auto_open_results = 1
" use unite (default 0)
" use arbitrary unite option (default is empty)
let g:octopress_unite_option = "-start-insert -horizontal -direction=botright -prompt-direction=below"
" use arbitrary unite source (default is 'file')
" let g:octopress_unite_source = "file"
let g:octopress_unite_source = "file"
let g:octopress_qfixgrep = 1
let g:octopress_post_suffix = "markdown"
let g:octopress_template_dir_path = "~/.vim/template/"

nnoremap [unite]on  :OctopressNew<CR>
nnoremap [unite]ol  :OctopressList<CR>
nnoremap [unite]og  :OctopressGrep<CR>
nnoremap [unite]oG  :OctopressGenerate<CR>
nnoremap [unite]od  :OctopressDeploy<CR>

" "vim-ref
" vim-ref のバッファを q で閉じられるようにする
augroup vimref_local_keymap
  autocmd!
  autocmd FileType ref-* nnoremap <buffer> <silent> q :<C-u>close<CR>
augroup END

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
" 最初の数行邪魔なので削除
function! g:ref_source_webdict_sites.je.filter(output)
  let l:str = substitute(a:output, "       単語帳", "", "g")
  return join(split(str, "\n")[28 :], "\n")
endfunction

function! g:ref_source_webdict_sites.ej.filter(output)
  let l:str = substitute(a:output, "       単語帳", "", "g")
  return join(split(str, "\n")[28 :], "\n")
endfunction

call altercmd#load()
CAlterCommand ej Ref webdict ej
CAlterCommand je Ref webdict je

"gitgutter
let g:gitgutter_diff_args = '-w'
nnoremap <silent> ,gg :<C-u>GitGutterToggle<CR>
nnoremap <silent> ,gh :<C-u>GitGutterLineHighlightsToggle<CR>

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
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
nmap gd :<C-u>OpenBrowserSearch -devdocs
vmap gd :<C-u>OpenBrowserSearch -devdocs <C-r><C-w><CR>

let g:openbrowser_browser_commands = [
      \ {"name": "xdg-open",
      \  "args": ["{browser}", "{uri}"]},
      \ {"name": "x-www-browser",
      \  "args": ["{browser}", "{uri}"]},
      \ {"name": "firefox",
      \  "args": ["{browser}", "{uri}"]},
      \ {"name": "luakit",
      \  "args": ["{browser}", "{uri}"]},
      \]

" indent guides
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level=2
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_color_change_percent = 30
let g:indent_guides_guide_size=1
let g:indent_guides_exclude_filetypes = ['help', 'vimfiler', 'tagbar', 'unite']
nmap <silent> <Leader>i <Plug>IndentGuidesToggle
augroup indent_guides_color
  autocmd!
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=236
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
augroup END

let g:rspec_command = "Dispatch rspec --format progress --no-profile {spec}"

if executable('spring')
  augroup spring
    autocmd!
    autocmd BufEnter * if exists("b:rails_root") | let g:rspec_command = "compiler rspec | set makeprg=spring | Make rspec --color --drb --tty {spec}" | endif
  endif
augroup END

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

" 常にprojectのroot Dirに移動する
function! ChangeCurrentDirectoryToProjectRoot()
  let root = unite#util#path2project_directory(expand('%'))
  execute 'lcd' root
endfunction

augroup project_root
  autocmd!
  autocmd BufEnter * :call ChangeCurrentDirectoryToProjectRoot()
augroup END

"" hilight minimap
" let g:minimap_highlight='Visual'

let g:vim_json_syntax_conceal = 0

" vim-coffee-script
" autocmd BufWritePost *.coffee silent make!

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
" <C-/> or <C-_> でコメントトグル
nmap <C-_> <Plug>(caw:hatpos:toggle)
vmap <C-_> <Plug>(caw:hatpos:toggle)

"auto-ctags
"" 保存時にtagsファイル作成
let g:auto_ctags = 1
let g:auto_ctags_filetype_mode = 1
let g:auto_ctags_directory_list = ['.git', '.svn']
set tags+=.git/tags;

"vim-multiple-cursors
"" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
    call s:DisableChangeCursorShape()
  endif
endfunction

"" Called once only when the multiple selection is canceled
"" (default <Esc>)
function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
    call s:EnableChangeCursorShape()
  endif
endfunction

highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
highlight link multiple_cursors_visual Visual

" easy-align
"" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"vim-unified-diff
set diffexpr=unified_diff#diffexpr()

" vimdiffで起動した際自動的に単語単位の差分(diffchar.vim)を有効にする
if &diff
  augroup enable_diffchar
    autocmd!
    autocmd VimEnter * execute "%SDChar"
  augroup END
endif

"agit.vim
augroup agit_local_keymap
  autocmd!
  autocmd FileType agit call s:my_agit_setting()
augroup END
function! s:my_agit_setting()
  nmap <buffer> J     <Plug>(agit-scrolldown-stat)
  nmap <buffer> K     <Plug>(agit-scrollup-stat)
  nmap <buffer> <C-n> <Plug>(agit-scrolldown-diff)
  nmap <buffer> <C-p> <Plug>(agit-scrollup-diff)
  nmap <buffer> u     <PLug>(agit-reload)
  nmap <buffer> yh    <Plug>(agit-yank-hash)
  nmap <buffer> cg    <Plug>(agit-print-commitmsg)
  nmap <buffer> q     <Plug>(agit-exit)
  nmap <buffer> C     <Plug>(agit-git-checkout)
  nmap <buffer> cb    <Plug>(agit-git-checkout-b)
  nmap <buffer> D     <Plug>(agit-git-branch-d)
  nmap <buffer> rs    <Plug>(agit-git-reset-soft)
  nmap <buffer> rm    <Plug>(agit-git-reset)
  nmap <buffer> rh    <Plug>(agit-git-reset-hard)
  nmap <buffer> rb    <Plug>(agit-git-rebase)
  nmap <buffer> ri    <Plug>(agit-git-rebase-i)
  nmap <buffer> di    <Plug>(agit-diff)
  "add
  nmap <buffer> ch    <Plug>(agit-git-cherry-pick)
  nmap <buffer> Rv    <Plug>(agit-git-revert)
endfunction

function! RangerExplorer(path)
  let path = a:path
    exec 'silent !ranger --choosefile=/tmp/vim_ranger_current_file ' . path
    if filereadable('/tmp/vim_ranger_current_file')
        exec 'edit ' . system('cat /tmp/vim_ranger_current_file')
        call system('rm /tmp/vim_ranger_current_file')
    endif
    redraw!
endfun

function! RangerOpenProjectRootDir()
  let root_path = unite#util#path2project_directory(expand('%'))
  :call RangerExplorer(root_path)
endfunction

function! RangerOpenCurrentDir() abort
  let current_path = '%p:h'
  :call RangerExplorer(current_path)
endfunction

nnoremap <silent>[unite]c :call RangerExplorer('%:p:h')<cr>
nnoremap <silent>[unite]f :call RangerOpenProjectRootDir()<cr>

"TweetVim
let g:tweetvim_display_icon=1
let g:tweetvim_async_post=1
let g:tweetvim_display_username=1
let g:tweetvim_tweet_per_page=20
let g:tweetvim_say_insert_account=1
nnoremap <leader>t :<C-u>TweetVimSay<CR>

" vim-auto-save
let g:auto_save = 1 " 自動保存
let g:auto_save_silent = 1  " do not display the auto-save notification
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option

"operator-surround
map  s  <Nop>
map  sa <Plug>(operator-surround-append)
map  sd <Plug>(operator-surround-delete)
nmap sc <Plug>(operator-surround-replace)
vmap sc <Plug>(operator-surround-replace)

let g:operator#surround#blocks =
      \ {
      \ '-': [
      \   { 'block' : ['```', '```'], 'motionwise' : ['line','block'], 'keys' : ['`'] },
      \   { 'block' : ['(', ')'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['p'] },
      \   { 'block' : ['(', ')'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['('] },
      \   { 'block' : ['{', '}'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['{'] },
      \   { 'block' : ['（', '）'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['P'] },
      \   { 'block' : ['「', '」'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['B'] },
      \   { 'block' : ['『', '』'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['D'] }
      \ ]
      \}


" vim-hier関連 {{{
" 波線で表示する場合は、以下の設定を行う
" エラーを赤字の波線で
execute "highlight qf_error_ucurl cterm=undercurl ctermfg=Red gui=undercurl guisp=Red"
let g:hier_highlight_group_qf  = "qf_error_ucurl"
" 警告を青字の波線で
execute "highlight qf_warning_ucurl cterm=undercurl ctermfg=Blue gui=undercurl guisp=Blue"
let g:hier_highlight_group_qfw = "qf_warning_ucurl"
"}}}'
