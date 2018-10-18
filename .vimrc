set encoding=utf-8
scriptencoding utf-8

filetype off
filetype plugin indent off

" autocmdのリセット
autocmd!
set nonumber     " 行番号を表示する
set cursorline " カーソル行の背景色を変える

augroup set_cursorline
  autocmd!
  autocmd InsertEnter,InsertLeave * set cursorline!  "redraw!
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
    if executable('gnome-terminal')
      autocmd InsertEnter * silent execute '!dconf write /org/gnome/terminal/legacy/profiles:/:a40311ba-987a-46d6-9b51-0eeaf9e48cde/cursor-shape \"ibeam\"'
      autocmd InsertLeave * silent execute '!dconf write /org/gnome/terminal/legacy/profiles:/:a40311ba-987a-46d6-9b51-0eeaf9e48cde/cursor-shape \"block\"'
      autocmd VimEnter * silent execute '!dconf write /org/gnome/terminal/legacy/profiles:/:a40311ba-987a-46d6-9b51-0eeaf9e48cde/cursor-shape \"block\"'
      autocmd VimLeave * silent execute '!dconf write /org/gnome/terminal/legacy/profiles:/:a40311ba-987a-46d6-9b51-0eeaf9e48cde/cursor-shape \"block\"'
      autocmd WinEnter * silent execute '!dconf write /org/gnome/terminal/legacy/profiles:/:a40311ba-987a-46d6-9b51-0eeaf9e48cde/cursor-shape \"block\"'
      autocmd WinLeave * silent execute '!dconf write /org/gnome/terminal/legacy/profiles:/:a40311ba-987a-46d6-9b51-0eeaf9e48cde/cursor-shape \"block\"'
    endif
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
set synmaxcol=300  " 長い行の場合、syntaxをoffにする
set list           " 不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮,nbsp:%,trail:_ " 不可視文字の表示記号指定
set t_Co=256 "ターミナルで256色利用
set iskeyword+=?,!,-,@-@ "?,!,@hogeなどをキーワードとする

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

augroup vimrc-highlight
  autocmd!
  autocmd Syntax off if 10000 > line('$') | syntax sync minlines=100 | endif
augroup END

" Charset, Line ending -----------------

set fileformats=unix,dos,mac  " LF, CRLF, CR
set ambiwidth=double  " UTF-8の□や○でカーソル位置がずれないようにする

set nospell

" カーソル移動系
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ
set scrolloff=8                " 上下8行の視界を確保
set sidescrolloff=16           " 左右スクロール時の視界を確保
set sidescroll=1               " 左右スクロールは一文字づつ行う
set lazyredraw                 " 描画を遅延させる
set ttyfast                    " カーソル移動高速化

augroup restore_cursor_position
  autocmd!
  autocmd BufReadPost * " 最後のカーソル位置を復元する
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
augroup END

"File処理関連
set confirm    " 保存されていないファイルがあるときは終了前に保存確認
set hidden     " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set nobackup   " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない
set autoread   " 外部でファイルに変更がされた場合は読みなおす

augroup vimrc-checktime "window移動/一定時間カーソルが停止した場合に強制的に読みなおす
  autocmd!
  set updatetime=400
  autocmd WinEnter * checktime
  autocmd CursorHold * checktime
augroup END


"検索関連
set hlsearch   " 検索文字列をハイライトする
set incsearch  " インクリメンタルサーチを行う
set ignorecase " 大文字と小文字を区別しない
set smartcase  " 大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
set wrapscan   " 最後尾まで検索を終えたら次の検索で先頭に移る
set gdefault   " 置換の時 g オプションをデフォルトで有効にする

"選択済テキストで検索
vnoremap // y/<C-R>"<CR>

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
inoremap <C-k> <C-o>D
inoremap <C-u> <C-\><C-o>d^
inoremap <C-w> <C-\><C-o>db

" vを二回で行末まで選択
vnoremap v $h

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

set viminfo+=n~/.viminfo


" 動作環境との統合
" OSのクリップボードをレジスタ指定無しで Yank, Put 出来るようにする
set clipboard=unnamed,unnamedplus

" インサートモードから抜けると自動的にIMEをオフにする
set iminsert=0
set imsearch=-1
""Ctrl-Cでインサートモードを抜ける
inoremap <C-c> <ESC>

if has('unix') && !has('gui_running')
 nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
endif

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

"tab/indentの設定
set shellslash
set expandtab                         " タブ入力を複数の空白入力に置き換える
set tabstop=2                         " 画面上でタブ文字が占める幅
set shiftwidth=2                      " 自動インデントでずれる幅
set softtabstop=2                     " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent                        " 改行時に前の行のインデントを継続する
set smartindent                       " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set indentkeys=!^F,o,O,0<Bar>,0=where " 自動インデントを発動させるタイミングを設定する

" 日本語ヘルプを利用する
set helplang=ja,en

".vimrcの編集用
nnoremap <Space>. :<C-u>tabedit $HOME/dotfiles/.vimrc<CR>

" q: のタイポ抑制
nnoremap q: :q
nnoremap ; :
vnoremap ; :
" remap record macro key from q to Q
nnoremap Q q
nnoremap q <Nop>

" マウスのミドルクリックによる貼付けをやめる
map <MiddleMouse>   <Nop>
map <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <MiddleMouse>   <Nop>
imap <2-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

"タブの設定
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> g'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" tc 新しいタブを右に作る
nnoremap <silent> gc :tabnew<CR>
" tn 新しいタブを一番右に作る
" nnoremap <silent> gn :tablast <bar> tabnew<CR>
" " tx タブを閉じる
nnoremap <silent> gq :tabclose<CR>
nnoremap <silent> gx :tabclose<CR>
nnoremap <silent> gp :tabprevious<CR>
nnoremap <silent> gn :tabnext<CR>


augroup add_syntax_hilight
  autocmd!
  "シンタックスハイライトの追加
  autocmd BufNewFile,BufRead *.json.jbuilder set filetype=ruby
  autocmd BufNewFile,BufRead Gemfile.local set filetype=ruby
  autocmd BufNewFile,BufRead *.erb                      set filetype=eruby
  autocmd BufNewFile,BufRead *.slim                     set filetype=slim
  autocmd BufNewFile,BufRead *.scss                     set filetype=scss.css
  autocmd BufNewFile,BufRead *.coffee                   set filetype=coffee
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
  autocmd BufRead,BufNewFile *.ts                       set filetype=typescript
augroup END

" set re=1

set runtimepath+=/home/iberianpig/.ghq/github.com/junegunn/fzf/bin/

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

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'

call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'tyru/open-browser.vim'


Plug 'itchyny/lightline.vim'
Plug 'AndrewRadev/switch.vim', {'on': ['Switch', 'SwitchReverse']}

Plug 'kana/vim-submode'
Plug 'tyru/caw.vim'

Plug 'osyo-manga/vim-over',  { 'on': ['OverCommandLineNoremap', 'OverCommandLineMap', 'OverCommandLine', 'OverCommandLineUnmap']}

" 辞書系
Plug 'thinca/vim-ref', { 'on': ['Ref', 'RefHistory'] }
Plug 'mfumi/ref-dicts-en'
Plug 'tyru/vim-altercmd'
Plug 'ujihisa/neco-look'

" カーソル下をハイライト
Plug 'osyo-manga/vim-brightest'

" 括弧補完
Plug 'cohama/lexima.vim'

" 補完系
Plug 'Shougo/neocomplete.vim' | Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets' | Plug 'honza/vim-snippets'

" %で閉じタグに飛ぶ
Plug 'tmhedberg/matchit'

" quickfixのエラーメッセージを下部に表示する
Plug 'dannyob/quickfixstatus', {'on': ['QuickfixStatusDisable', 'QuickfixStatusEnable']}

" 非同期処理でLinterを動かす
Plug 'w0rp/ale'

" aleの結果をlightlineに出力
Plug 'maximbaz/lightline-ale'

" 非同期バッチをTmuxやTerminalに渡して処理出来る
Plug 'tpope/vim-dispatch', {'on': ['Dispatch', 'FocusDispatch','Spawn', 'Start', 'Copen']}

" テストランナー
Plug 'janko-m/vim-test'

" インデントの可視化
Plug 'nathanaelkane/vim-indent-guides', {'on': ['IndentGuidesEnable', 'IndentGuidesToggle', 'IndentGuidesDisable', ]}

" Git/SVNの差分箇所をマークで表示
Plug 'mhinz/vim-signify'

" Git diff用
Plug 'tpope/vim-fugitive', {'on': ['Gdiff']}

" 自動整形プラグイン
Plug 'Chiel92/vim-autoformat'

" PJ毎の稼働時間を記録
Plug 'wakatime/vim-wakatime'

"  Yank
Plug 'LeafCage/yankround.vim'

" 自動保存
Plug 'vim-scripts/vim-auto-save'

" 再帰的なfジャンプ
Plug 'rhysd/clever-f.vim'

" Surround
Plug 'tpope/vim-surround'

" Rename
Plug 'qpkorr/vim-renamer', { 'on': 'Renamer'}

" editorconfig
Plug 'editorconfig/editorconfig-vim', { 'on': ['EditorConfigReload']}

" cd project-root
" Plug 'airblade/vim-rooter'

" syntax highlighter
Plug 'todesking/ruby_hl_lvar.vim', { 'for' : ['ruby'] }

""Markdown
" table
" Plug 'godlygeek/tabular' ",    {'on': ['AddTabularPipeline', 'Tabularize', 'GTabularize', 'AddTabularPattern']}
" syntax
" Plug 'rcmdnk/vim-markdown',  { 'for': ['markdown'] }
" 日本語の句読点をTextObjectの区切りと扱う 
Plug 'deton/jasentence.vim', { 'for': ['markdown'] }
" マークダウンをブラウザ上でHTMLレンダリング
Plug 'kannokanno/previm', {'for': ['markdown'] }
Plug 'rhysd/vim-gfm-syntax', { 'for': 'markdown' }


""Rails
" 規約ベースのコードジャンプ、b:rails_rootを定義
Plug 'tpope/vim-rails', { 'for': ['ruby'] }
" slimのsyntax highlight
Plug 'slim-template/vim-slim', { 'for': ['slim'] }

"" perl
Plug 'hotchpotch/perldoc-vim', { 'for': ['perl'] }
Plug 'vim-perl/vim-perl', { 'for': ['perl'] }

" php
Plug 'vim-scripts/php.vim-html-enhanced', { 'for': ['php'] }

" html
Plug 'othree/html5.vim', {'for':['html']}

"" javascript
Plug 'elzr/vim-json',                          {'for':['json']}
Plug 'othree/yajs.vim',                        {'for':['javascript', 'html']}
Plug 'vim-scripts/JavaScript-Indent',          {'for':['javascript', 'html']}
Plug 'pangloss/vim-javascript',                {'for':['javascript', 'html']}
Plug 'othree/javascript-libraries-syntax.vim', {'for':['javascript', 'html']}
Plug 'othree/es.next.syntax.vim',              {'for':['javascript', 'html']}
Plug 'MaxMEllon/vim-jsx-pretty',               {'for':['javascript', 'html']}

"" typescript
Plug 'leafgarland/typescript-vim', {'for':['typescript', 'tsx']}
Plug 'Quramy/tsuquyomi', {'for':['typescript', 'tsx']}
" graphql
Plug 'jparise/vim-graphql',                    {'for':['javascript', 'html']}


" css
Plug 'lilydjwg/colorizer'
Plug 'JulesWang/css.vim',         {'for':['scss', 'css']}
Plug 'hail2u/vim-css3-syntax',    {'for':['scss', 'css']}
Plug 'csscomb/vim-csscomb',       {'for':['scss', 'css']}
Plug 'cakebaker/scss-syntax.vim', {'for':['scss']}

" log
Plug 'vim-scripts/AnsiEsc.vim', {'on': ['DM', 'RWP', 'AnsiEsc', 'RM', 'SM', 'WLR', 'SWP']}


"colorscheme
Plug 'w0ng/vim-hybrid'
Plug 'miyakogi/seiya.vim'

"help
Plug 'vim-jp/vimdoc-ja'
Plug 'KabbAmine/zeavim.vim'

"readline lik keybindings
Plug 'tpope/vim-rsi'

"create vim plugin's skeleton
Plug 'mopp/layoutplugin.vim', { 'on' : 'LayoutPlugin'} 

"unite like serching interface
Plug 'junegunn/fzf'
Plug 'tweekmonster/fzf-filemru'

"solidity
Plug 'tomlion/vim-solidity'

" nginx
Plug 'chr4/nginx.vim'

" ローカル管理のPlugin
Plug '~/.ghq/github.com/iberianpig/tig-explorer.vim' | Plug 'rbgrouleff/bclose.vim'
Plug '~/.ghq/github.com/iberianpig/ranger-explorer.vim'

" Initialize plugin system
call plug#end()

" Required:
filetype plugin indent on
syntax on

" ...
" 読み込んだプラグインの設定
" ...

" set background=light "明るめの背景
set background=dark "暗めの背景

colorscheme hybrid
let g:seiya_auto_enable=1

" カーソル行にアンダーラインを引く(color terminal)
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" " エラー箇所の行番号左にSignを表示

" highlight lines in Sy and vimdiff etc.)

" highlight DiffAdd           cterm=bold ctermbg=none ctermfg=119
" highlight DiffDelete        cterm=bold ctermbg=none ctermfg=167
" highlight DiffChange        cterm=bold ctermbg=none ctermfg=227

" highlight signs in Sy

highlight SignifySignAdd    cterm=bold ctermbg=235  ctermfg=155
highlight SignifySignDelete cterm=bold ctermbg=235  ctermfg=196
highlight SignifySignChange cterm=bold ctermbg=235  ctermfg=111

" lightline {{{
" available colorscheme:
" wombat, solarized, powerline, jellybeans, Tomorrow,
" Tomorrow_Night, Tomorrow_Night_Blue, Tomorrow_Night_Eighties,
" PaperColor, seoul256, landscape and 16color
let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], [ 'ctrlpmark'] ],
      \   'right': [[ 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ], ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
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
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component_type':      {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ },
      \ 'tabline':             {
      \   'left':              [ [ 'tabs' ] ],
      \   'right':             [ [ 'currentworkingdir' ] ],
      \ },
      \}

function! MyModified()
  return &filetype =~? 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyPercent()
  return &filetype =~? 'vimfiler' ? '' : (100 * line('.') / line('$')) . '%'
endfunction

function! MyLineInfo()
  return &filetype =~? 'vimfiler\|unite' ? '' : printf('%3d:%-2d', line('.'), col('.'))
endfunction

function! MyReadonly()
  return &filetype !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname  ==# 'ControlP' ? g:lightline.ctrlp_item :
        \ fname ==# '__Tagbar__' ? g:lightline.fname :
        \ fname =~? '__Gundo\|NERD_tree' ? '' :
        \ &filetype   ==# 'vimfiler' ? vimfiler#get_status_string() :
        \ &filetype   ==# 'unite' ? unite#get_status_string() :
        \ &filetype   ==# 'vimshell' ? vimshell#get_status_string() :
        \ (''   !=# MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (''   !=# fname ? MyStatusPath() . '/' . fname : '[No Name]') .
        \ (''   !=# MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyStatusPath()
  if exists('b:my_status_path')
    return b:my_status_path
  endif
  let path  = expand('%:p:h')
  let gpath = finddir('.git', path . ';.;')

  if gpath ==# ''
    let gpath = findfile('Rakefile', path . ';')
  endif

  if gpath ==# ''
    let b:my_status_path = fnamemodify(path, ':~:h')
    return b:my_status_path
  endif

  if gpath ==# '.git' || gpath ==# 'Rakefile'
    let b:my_status_path = fnamemodify(path, ':t')
  else
    let gpath = fnamemodify(gpath, ':h:h') . '/'
    let b:my_status_path = substitute(path, gpath, '', '')
  endif

  return b:my_status_path
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat) : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fileencoding) ? &fileencoding : &encoding) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname  ==# '__Tagbar__' ? 'Tagbar' :
        \ fname ==# 'ControlP' ? 'CtrlP' :
        \ fname ==# '__Gundo__' ? 'Gundo' :
        \ fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~# 'NERD_tree' ? 'NERDTree' :
        \ &filetype   ==# 'unite' ? 'Unite' :
        \ &filetype   ==# 'vimfiler' ? 'VimFiler' :
        \ &filetype   ==# 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 70 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~# 'ControlP'
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

" neocomplete {{{
let g:neocomplete#enable_at_startup               = 1
" let g:neocomplete#auto_completion_start_length    = 2
let g:neocomplete#enable_ignore_case              = 1
" let g:neocomplete#enable_smart_case               = 1
let g:neocomplete#enable_cursor_hold_i            = 1
" let g:neocomplete#enable_camel_case               = 1
" let g:neocomplete#enable_fuzzy_completion         = 1
" let g:neocomplete#use_vimproc                     = 1
let g:neocomplete#lock_buffer_name_pattern        = '\*ku\*'

" docstringは表示しない
set completeopt-=preview

let g:neocomplete#sources#dictionary#dictionaries = {
\   'ruby': $HOME . '/.vim/bundle/dicts/ruby.dict',
\ }

" for turn_vim
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" "NeoSnippet.vim
let g:neosnippet#enable_snipmate_compatibility = 1
" remove ${x} marker when switching normal mode
let g:neosnippet#enable_auto_clear_markers = 1
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

" enable ruby & rails snippet only rails file
function! s:RailsSnippet()
  if exists('b:rails_root') && (&filetype ==# 'ruby')
    set filetype=ruby.rails
  endif
endfunction

function! s:RSpecSnippet()
  if (expand('%') =~# '_spec\.rb$') || (expand('%') =~# '^spec.*\.rb$')
    set filetype=ruby.rspec
  endif
endfunction

function! s:MinitestSnippet()
  if (expand('%') =~# '_test\.rb$') || (expand('%') =~# '^test.*\.rb$')
    set filetype=ruby.minitest
  endif
endfunction

augroup rails_snippet
  autocmd!
  au BufEnter * call s:RailsSnippet()
  au BufEnter * call s:RSpecSnippet()
  au BufEnter * call s:MinitestSnippet()
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

" filetype=javascript で include 補完を無効にする
call neocomplete#custom#source('include',
      \ 'disabled_filetypes', {'javascript' : 1})

" filetype=javascript で tag 補完を無効にする
call neocomplete#custom#source('tag',
      \ 'disabled_filetypes', {'javascript' : 1})

" すべての filetype で member 補完を無効にする
call neocomplete#custom#source('tag',
      \ 'disabled_filetypes', {'_' : 1})


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
nnoremap <silent> <C-s> :OverCommandLine<CR>%s/<C-r><C-w>//<Left>
vnoremap <silent> <C-s> y:OverCommandLine<CR>%s/<C-r>"//<Left>
vnoremap <silent> :s :OverCommandLine<CR>s//<Left>
" カーソル下の単語をハイライト付きで置換
nnoremap s :OverCommandLine<CR>%s/<C-r><C-w>//<Left>
" コピーした文字列をハイライト付きで置換
vnoremap s y:OverCommandLine<CR>%s/<C-r>=substitute(@0, '/', '/', 'g')<CR>//<Left>

" <C-v> 時に特殊文字を挿入
OverCommandLineMap <C-v> <C-q>

" fzf
" quickfixに流す
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-o': 'edit',
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~40%' }

"" fzf-filemru
let g:fzf_filemru_bufwrite=1

nmap <Space> [fzf]
vmap <Space> <Nop>
vmap <Space> [fzf]

""スペースキーとaキーでカレントディレクトリを表示
nnoremap <silent> [fzf]a :call fzf#vim#files(expand("%:p:h"), fzf#vim#with_preview())<CR>
"スペースキーとmキーでプロジェクト内で最近開いたファイル一覧を表示
" nnoremap <silent> [fzf]m :<C-u>fzfWithProjectDir<Space>file_mru<CR>
" "スペースキーとMキーで最近開いたファイル一覧を表示
" nnoremap <silent> [fzf]M :<C-u>fzf<Space>file_mru<CR>
" nnoremap <silent> [fzf]m :call fzf#run({'source': v:oldfiles, 'options': '-m -x +s'})<CR>
nnoremap <silent> [fzf]m :ProjectMru --tiebreak=end<cr>
nnoremap <silent> [fzf]M :FilesMru --tiebreak=end<cr>

nnoremap <silent> [fzf]<CR> :FZF<CR>

" "スペースキーとbキーでバッファを表示
nnoremap <silent> [fzf]b :Buffers<CR>

nnoremap <silent> [fzf]h :<C-u>Helptags<CR>


" markdownの設定
" see /usr/share/vim/vim80/syntax/*.vim
let g:markdown_fenced_languages = ['ruby', 'json', 'vim', 'sh', 'javascript']
"previm
augroup PrevimSettings
  autocmd!
  autocmd  FileType markdown call s:loadPrevimSetting()
augroup END

function! s:loadPrevimSetting()
  let g:previm_enable_realtime = 1
  nmap <Leader>r :PrevimOpen<CR>
endfunction


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
      \     'url': 'https://translate.google.com/#auto/ja/%s',
      \   },
      \   'ej': {
      \     'url': 'http://eow.alc.co.jp/search?q=%s',
      \   },
      \   'alc': {
      \     'url': 'http://eow.alc.co.jp/search?q=%s',
      \   },
      \ }

" デフォルトサイト
let g:ref_source_webdict_sites.default = 'ej'

" 出力に対するフィルタ
" 最初の数行邪魔なので削除
function! g:ref_source_webdict_sites.je.filter(output)
  let l:str = substitute(a:output, '       単語帳', '', 'g')
  return join(split(str, "\n")[28 :], "\n")
endfunction

function! g:ref_source_webdict_sites.ej.filter(output)
  let l:str = substitute(a:output, '       単語帳',' ', 'g')
  return join(split(str, "\n")[28 :], "\n")
endfunction

call altercmd#load()
CAlterCommand ej Ref webdict ej
CAlterCommand je Ref webdict je

"gista
let g:gista#github_user = 'iberianpig'
let g:gista#post_private = 1

" for open-browser plugin
" nmap gx <Plug>(openbrowser-smart-search)
nmap gx :OpenBrowserSmartSearch <C-r><C-w> <CR>
vmap gx y:<C-u>OpenBrowserSmartSearch <C-R>"<CR>
nmap gd :<C-u>OpenBrowserSmartSearch -devdocs <C-r><C-w> <CR>
vmap gd y:<C-u>OpenBrowserSmartSearch -devdocs <C-R>"<CR>
nmap ga :<C-u>OpenBrowserSmartSearch -alc <C-R>"<CR>
vmap ga y:<C-u>OpenBrowserSmartSearch -alc <C-R>"<CR>
vmap gex y:<C-u>OpenBrowserSmartSearch -googletranslate_en <C-R>"<CR>
vmap gjx y:<C-u>OpenBrowserSmartSearch -googletranslate_ja <C-R>"<CR>

" reloadしたら消えてしまう
if !exists('g:openbrowser_search_engines')
  let g:openbrowser_search_engines = {
        \ 'googletranslate_en': 'https://translate.google.com/#ja/en/{query}',
        \ 'googletranslate_ja': 'https://translate.google.com/#en/ja/{query}'
        \ }
endif

let g:openbrowser_browser_commands = [
      \ {'name': 'xdg-open',
      \  'args': ['{browser}', '{uri}']},
      \ {'name': 'x-www-browser',
      \  'args': ['{browser}', '{uri}']},
      \ {'name': 'firefox',
      \  'args': ['{browser}', '{uri}']},
      \ {'name': 'luakit',
      \  'args': ['{browser}', '{uri}']},
      \]

" indent guides
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level=2
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_color_change_percent = 30
let g:indent_guides_guide_size=1
let g:indent_guides_exclude_filetypes = ['help', 'vimfiler', 'tagbar', 'unite']
nmap <silent> <Leader>ig :IndentGuidesToggle<CR>
augroup indent_guides_color
  autocmd!
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=236
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=238
augroup END

" test setting
let test#strategy = 'dispatch'

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

let test#ruby#rspec#options = {
  \ 'nearest': '--backtrace',
  \ 'file':    '--format documentation',
  \ 'suite':   '--tag ~slow',
\}

" docker and rspec
" https://qiita.com/joker1007/items/4dbff328f39c11e732af
function! DockerTransformer(cmd) abort
  if $SPEC_CONTAINER_NAME !=# ''
    let prefix = 'docker-compose exec ' . $SPEC_CONTAINER_NAME . ' bundle exec '
  else
    let prefix = 'bundle exec '
  endif
  let g:dispatch_compilers = {}
  let g:dispatch_compilers[prefix] = ''
  return  prefix . a:cmd
endfunction

let test#ruby#rspec#executable = 'rspec'
let g:test#custom_transformations = {'docker': function('DockerTransformer')}
let g:test#transformation = 'docker'

let g:vim_json_syntax_conceal = 0

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

highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
highlight link multiple_cursors_visual Visual

" easy-align
"" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


nmap , [explorer]
vmap , <Nop>
vmap , [explorer]
nnoremap [explorer]T :TigOpenCurrentFile<CR>
nnoremap [explorer]t :TigOpenProjectRootDir<CR>
nnoremap [explorer]g :TigGrep<CR>
" nnoremap [explorer]gw :<C-u>:TigGrep<Space>\<<C-R><C-W>\><CR>
""選択状態のキーワードで検索"
vnoremap [explorer]g y:TigGrep<Space><C-R>"
""カーソル上のキーワードで検索
nnoremap [explorer]r :TigGrepResume<CR>
"" open tig blame with current file
nnoremap [explorer]b :TigBlame<CR>

nnoremap [explorer]s :Tig status<CR>
nnoremap [explorer]y :Tig stash<CR>
" nnoremap [explorer]r :Tig refs<CR>

" let g:tig_explorer_orig_tigrc='~/.tigrc'

" ranger-explorer
nnoremap [explorer]c :<C-u>RangerOpenCurrentDir<CR>
nnoremap [explorer]f :<C-u>RangerOpenProjectRootDir<CR>

" vim-auto-save
let g:auto_save_silent = 1  " do not display the auto-save notification
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option

" 自動保存の有効・無効の設定
function! s:auto_save_detect() abort
  " read onlyの場合は自動保存しない"
  " filenameがResultの場合は自動保存しない(dbext.vimで作られる一時ファイル)
  if &readonly || expand('%:t') ==# 'Result'
    let g:auto_save = 0 " 自動保存しない
  else
    let g:auto_save = 1 " 自動保存
  end
endfunction

augroup switch_auto_save
  autocmd!
  au BufEnter * call s:auto_save_detect()
augroup END

" gtags
let g:Gtags_Auto_Update = 1
let g:Gtags_OpenQuickfixWindow = 1
"" 検索結果Windowを閉じる
nnoremap <C-q> <C-w>j<C-w>q
" "" Grep 準備
" nnoremap <C-g> :Gtags -g
"" このファイルの関数一覧
nnoremap <C-h> :Gtags -f %<CR>
"" カーソル以下の定義元を探す
nnoremap <C-j> :Gtags <C-r><C-w><CR>
vnoremap <C-j> y:Gtags <C-r>"<CR>
"" カーソル以下の使用箇所を探す
nnoremap <C-k> :Gtags -r <C-r><C-w><CR>
vnoremap <C-k> y:Gtags -r <C-r>"<CR>

"" 検索結果に移動
nnoremap <C-c> :cc<CR>

"" 次の検索結果に移動
nnoremap <C-n> :cn<CR>
"" 前の検索結果に移動
nnoremap <C-p> :cp<CR>

"ale
let g:ale_set_quickfix = 1
let g:Qfstatusline#UpdateCmd = function('lightline#update')
let g:ale_lint_on_enter=0 "ファイルを開いた時にチェックを実行。初期値1。設定で0に。
let g:ale_lint_on_filetype_changed=0 "filetypeが変わった時にチェックを実行。初期値1。
let g:ale_lint_on_save=0 "ファイルを保存する時にチェックを実行。初期値1。
let g:ale_lint_on_text_changed=0 "内容が変更された時にチェックを実行。初期値1。余りにガチャガチャしすぎなら0に。
let g:ale_lint_on_insert_leave=0 "インサートモードを終了する時にチェックを実行。初期値0。text_changedを0にしたらこちらを1にした方が良い。
let g:ale_maximum_file_size=0 "チェックを行う最大ファイルサイズ。初期値は0。1以上に設定するとそのbyte数より大きいファイルをチェックしない。

let g:ale_linters = {'javascript': ['eslint', 'flow']}

let g:ale_fixers = {
      \'ruby':       ['rubocop'],
      \'json':       ['fixjson'],
      \'javascript': ['eslint']
      \}
nnoremap <leader>w :ALELint<CR>
nnoremap <leader>f :ALEFix<CR>

" highlight clear ALEErrorSign " otherwise uses error bg color (typically red)
" highlight clear ALEWarningSign " otherwise uses error bg color (typically red)
" let g:ale_sign_error = 'X' " could use emoji
" let g:ale_sign_warning = '?' " could use emoji
let g:ale_statusline_format = ['X %d', '? %d', '']
" %linter% is the name of the linter that provided the message
" %s is the error or warning message
let g:ale_echo_msg_format = '%linter% says %s'
" Map keys to navigate between lines with errors and warnings.
nnoremap <leader>an :ALENextWrap<cr>
nnoremap <leader>ap :ALEPreviousWrap<cr>

" yankround.vim
call submode#enter_with('yankround', 'nv', 'r', 'p',     '<Plug>(yankround-p)')
call submode#map('yankround',        'n', 'r', '<C-p>', '<Plug>(yankround-prev)')
call submode#map('yankround',        'n', 'r', '<C-n>', '<Plug>(yankround-next)')

let g:brightest#highlight = {
\   "group" : "BrightestUnderline"
\}

let g:brightest#pattern = '\k\+'
" let g:brightest#enable_clear_highlight_on_CursorMoved = 1
let g:brightest#enable_on_CursorHold = 1
