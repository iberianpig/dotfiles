" autocmdのリセット
autocmd! 
set number     " 行番号を表示する
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
set synmaxcol=300   " 長い行の場合、syntaxをoffにする
set list           " 不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮,nbsp:%,trail:_ " 不可視文字の表示記号指定
set t_Co=256 "ターミナルで256色利用

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

" Charset, Line ending -----------------
set encoding=utf-8
scriptencoding utf-8

set ffs=unix,dos,mac  " LF, CRLF, CR
if exists('&ambiwidth')
  set ambiwidth=double  " UTF-8の□や○でカーソル位置がずれないようにする
endif

set nospell

" カーソル移動系
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ
set scrolloff=4                " 上下8行の視界を確保
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
inoremap <C-k> <C-o>D<Right>
inoremap <C-u> <C-o>d^
inoremap <C-w> <C-o>db

" "カーソルキーによる移動を折り返されたテキストでも自然に振る舞うようにする
nnoremap <Up> gk
nnoremap <Down> gj

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
  " ESC後にすぐ反映されない対策
 nnoremap <silent> <ESC> :nohlsearch<CR>:set iminsert=0 <CR>
 " :redraw!<CR>:redraws!<CR>
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
" remap record macro key from q to Q
nnoremap Q q
nnoremap q <Nop>


"タブの設定
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
  autocmd BufNewFile,BufRead *.json.jbuilder            set ft=ruby
  autocmd BufNewFile,BufRead *.erb                      set ft=eruby
  autocmd BufNewFile,BufRead *.scss                     set ft=scss.css
  autocmd BufNewFile,BufRead *.coffee                   set ft=coffee
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set ft=markdown
augroup END

let g:ruby_path = system('echo $HOME/.rbenv/shims')

" 正規表現エンジン
set re=1

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
NeoBundle     'Shougo/neocomplete.vim'
NeoBundle     'Shougo/neomru.vim'
NeoBundle     'Shougo/vimshell.git'
" NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }
" vimprocのインストールとbuild
" " 自動でインストールしてビルド(make)してくれる
NeoBundle     'Shougo/vimproc', {
      \       'build' : {
      \       'windows' : 'make -f make_mingw32.mak',
      \       'cygwin' : 'make -f make_cygwin.mak',
      \       'mac' : 'make -f make_mac.mak',
      \       'linux' : 'make',
      \       'unix' : 'gmake',
      \       },
      \       }
NeoBundle     'Shougo/neosnippet.vim'
NeoBundle     'Shougo/neosnippet-snippets'
NeoBundle     'honza/vim-snippets'
NeoBundleLazy 'tpope/vim-repeat', {'autoload': {'mappings': [['n', '<Plug>(Repeat']]}}
NeoBundle     'Shougo/unite.vim'
NeoBundle     'tsukkee/unite-help'
NeoBundle     'ujihisa/unite-colorscheme'
NeoBundle     'osyo-manga/unite-quickfix.git'
NeoBundle     'thinca/vim-quickrun'
NeoBundleLazy "tyru/open-browser.vim", {
\             'autoload' : {
\             'functions' : "OpenBrowser",
\             'commands'  : ["OpenBrowser", "OpenBrowserSearch"],
\             'mappings'  : "<Plug>(openbrowser-smart-search)"
\             },
\}
NeoBundleLazy 'sgur/vim-operator-openbrowser', {'autoload': {'mappings': [['nx', '<Plug>(operator-openbrowser']]}}
NeoBundleLazy 'thinca/vim-guicolorscheme', {'autoload': {'commands': [{'complete': 'customlist,s:Colorscheme_Complete', 'name': 'GuiColorScheme'}]}}
NeoBundle     'itchyny/lightline.vim'
NeoBundleLazy 'junegunn/vim-easy-align', {'autoload': {'mappings': ['<Plug>(EasyAlignOperator)', ['sxn', '<Plug>(EasyAlign)'], ['sxn', '<Plug>(LiveEasyAlign)'], ['sxn', '<Plug>(EasyAlignRepeat)']], 'commands': ['EasyAlign', 'LiveEasyAlign']}}
NeoBundleLazy 'AndrewRadev/switch.vim', {'autoload': {'commands': ['Switch', 'SwitchReverse']}}
NeoBundle     'kana/vim-submode'
NeoBundle     'tyru/caw.vim'
NeoBundle     'mattn/emmet-vim'
NeoBundleLazy 'osyo-manga/vim-over', {'autoload': {'mappings': [['n', '<Plug>(over-restore-']], 'commands': ['OverCommandLineNoremap', 'OverCommandLineMap', 'OverCommandLine', 'OverCommandLineUnmap']}}
NeoBundle     'mattn/webapi-vim'
NeoBundle     'Shougo/unite-outline'
NeoBundleLazy 'ujihisa/unite-locate', {'autoload': {'unite_sources': ['locate']}}
NeoBundleLazy 'ujihisa/quicklearn', {'autoload': {'unite_sources': ['quicklearn']}}
NeoBundleLazy 'thinca/vim-ref', {'autoload': {'unite_sources': ['ref'], 'mappings': [['sxn', '<Plug>(ref-keyword)']], 'commands': [{'complete': 'customlist,ref#complete', 'name': 'Ref'}, 'RefHistory']}}
NeoBundleLazy 'taka84u9/vim-ref-ri', {'autoload': {'commands': ['HtmlHiLink']}}
NeoBundle     'mfumi/ref-dicts-en'
NeoBundle     'tyru/vim-altercmd'
NeoBundle     'ujihisa/neco-look'
NeoBundle     'cohama/lexima.vim'
NeoBundleLazy 'sgur/vim-gitgutter', {'autoload': {'mappings': [['n', '<Plug>GitGutter']], 'commands': ['GitGutterToggle', 'GitGutterPrevHunk', 'GitGutter', 'GitGutterLineHighlightsToggle', 'GitGutterRevertHunk', 'GitGutterPreviewHunk', 'GitGutterSignsEnable', 'GitGutterNextHunk', 'GitGutterDisable', 'GitGutterStageHunk', 'GitGutterEnable', 'GitGutterSignsToggle', 'GitGutterAll', 'GitGutterLineHighlightsEnable', 'GitGutterLineHighlightsDisable', 'GitGutterDebug', 'GitGutterSignsDisable']}}
NeoBundle     'edsono/vim-matchit'
NeoBundleLazy 'mattn/benchvimrc-vim', {'autoload': {'commands': [{'complete': 'file', 'name': 'BenchVimrc'}]}}
NeoBundleLazy 'rking/ag.vim', {'autoload': {'commands': [{'complete': 'file', 'name': 'AgFromSearch'}, {'complete': 'file', 'name': 'LAgBuffer'}, {'complete': 'file', 'name': 'LAgAdd'}, {'complete': 'file', 'name': 'LAg'}, {'complete': 'help', 'name': 'LAgHelp'}, {'complete': 'file', 'name': 'AgBuffer'}, {'complete': 'file', 'name': 'AgFile'}, {'complete': 'file', 'name': 'AgAdd'}, {'complete': 'file', 'name': 'Ag'}, {'complete': 'help', 'name': 'AgHelp'}]}}
NeoBundleLazy 'pocke/vim-hier', {'autoload': {'commands': ['HierStart', 'HierUpdate', 'HierClear', 'HierStop']}}
NeoBundleLazy 'dannyob/quickfixstatus', {'autoload': {'commands': ['QuickfixStatusDisable', 'QuickfixStatusEnable']}}
NeoBundle     'osyo-manga/shabadou.vim'
NeoBundle     'osyo-manga/vim-watchdogs'
NeoBundleLazy 'KazuakiM/vim-qfstatusline', {'autoload': {'commands': ['QfstatuslineUpdate']}}
NeoBundleLazy 'KazuakiM/vim-qfsigns', {'autoload': {'commands': ['QfsignsClear', 'QfsignsJunmp', 'QfsignsUpdate']}}
NeoBundleLazy 'tpope/vim-dispatch', {'autoload': {'commands': [{'complete': 'customlist,dispatch#make_complete', 'name': 'Make'}, {'complete': 'customlist,dispatch#command_complete', 'name': 'Dispatch'}, {'complete': 'customlist,dispatch#command_complete', 'name': 'FocusDispatch'}, {'complete': 'customlist,dispatch#command_complete', 'name': 'Spawn'}, {'complete': 'customlist,dispatch#command_complete', 'name': 'Start'}, 'Copen']}}
NeoBundle     'vim-scripts/dbext.vim'
NeoBundleLazy 'nathanaelkane/vim-indent-guides', {'augroup': 'indent_guides', 'autoload': {'mappings': [['n', '<Plug>IndentGuides']], 'commands': ['IndentGuidesEnable', 'IndentGuidesToggle', 'IndentGuidesDisable']}}
NeoBundleLazy 'Chiel92/vim-autoformat', {'autoload': {'commands': ['CurrentFormatter', 'RemoveTrailingSpaces', {'complete': 'filetype', 'name': 'Autoformat'}, 'NextFormatter', 'PreviousFormatter']}}
NeoBundleLazy 'itchyny/thumbnail.vim', {'autoload': {'mappings': [['sxn', '<Plug>(thumbnail)']], 'commands': [{'complete': 'customlist,thumbnail#complete', 'name': 'Thumbnail'}]}}
NeoBundle     'wakatime/vim-wakatime'
NeoBundle     'LeafCage/yankround.vim'
NeoBundle     'Shougo/neco-syntax'
NeoBundle     'textobj-user'
NeoBundle     'vim-scripts/vim-auto-save'
NeoBundle     'rhysd/clever-f.vim'
NeoBundleLazy 'deton/jasentence.vim', {  "autoload" : {"filetypes" : ["markdown"]} }
NeoBundleLazy 'kannokanno/previm', {  "autoload" : {'commands': ['PrevimOpen'] }}
NeoBundle     'kana/vim-operator-user'
NeoBundleLazy 'rhysd/vim-operator-surround', {'autoload': {'mappings': [['nx', '<Plug>(operator-surround'], ['n', '<Plug>(operator-surround-repeat)']]}}
NeoBundleLazy 'glidenote/memolist.vim', {'autoload': {'commands': ['MemoNewCopyingMeta', 'MemoList', 'MemoGrep', 'MemoNew', 'MemoNewWithMeta']}}
NeoBundleLazy 'upamune/esa.vim', {'autoload': {'commands': [{'complete': 'customlist,s:CompleteArgs', 'name': 'Esa'}]}}
NeoBundleLazy 'sjl/gundo.vim', {'autoload': {'commands': ['GundoHide', 'GundoShow', 'GundoRenderGraph', 'GundoToggle']}}
NeoBundleLazy 'LeafCage/nebula.vim', {'autoload': {'commands': ['NebulaPutLazy', 'NebulaPutFromClipboard', 'NebulaYankOptions', 'NebulaYankConfig', 'NebulaPutConfig', 'NebulaYankTap']}}
NeoBundleLazy 'renamer.vim', {'augroup': 'Renamer', 'autoload': {'commands': [{'complete': 'dir', 'name': 'Renamer'}]}}
NeoBundleLazy 'editorconfig/editorconfig-vim', {'autoload': {'commands': ['EditorConfigReload']}}
NeoBundle     'thinca/vim-prettyprint'

"session管理
NeoBundleLazy 'tpope/vim-obsession', {'autoload': {'commands': [{'complete': 'file', 'name': 'Obsession'}]}}

" git
NeoBundle     'tpope/vim-fugitive'
NeoBundleLazy 'moznion/github-commit-comment.vim', {'autoload': {'commands': ['GitHubFetchCommitComment', 'GitHubLineComment', 'GitHubFileComment', 'GitHubCommitComment']}}
NeoBundle     'lambdalisue/vim-unified-diff'
NeoBundleLazy 'lambdalisue/vim-gista', {'autoload': {'commands': [{'complete': 'customlist,gista#command#complete', 'name': 'Gista'}]}}
NeoBundle     'lambdalisue/vim-gista-unite'
NeoBundle     'Kocha/vim-unite-tig'

" Markdown syntax
NeoBundleLazy "rcmdnk/vim-markdown",           {  "autoload" : {"filetypes" : ["markdown"]} }
NeoBundleLazy 'godlygeek/tabular',             {'autoload': {'commands': ['AddTabularPipeline', {'complete': 'customlist,<SID>CompleteTabularizeCommand', 'name': 'Tabularize'}, {'complete': 'customlist,<SID>CompleteTabularizeCommand', 'name': 'GTabularize'}, 'AddTabularPattern']}}
NeoBundleLazy 'pekepeke/vim-operator-tabular', {'autoload': {'commands': ['TabularDebugLog']}}
NeoBundle     'pekepeke/vim-csvutil'

" ctags
NeoBundle 'tsukkee/unite-tag'

" rubyでのみvim-rubyを読み込む
NeoBundleLazy 'vim-ruby/vim-ruby', {  "autoload" : {"filetypes" : ["ruby"]} }
NeoBundleLazy 'pocke/dicts', { "autoload" : { "filetypes" : ["ruby"] }  }
NeoBundleLazy 'tpope/vim-bundler', { "autoload" : { "filetypes" : ["ruby"] }  }
NeoBundleLazy 'thoughtbot/vim-rspec', { "autoload" : { "filetypes" : ["ruby"] }  }
NeoBundleLazy 'todesking/ruby_hl_lvar.vim', { "autoload" : { "filetypes" : ["ruby"] }  }
NeoBundleLazy 'marcus/rsense', { "autoload" : { "filetypes" : ["ruby"] }  }

"rails
NeoBundle 'basyura/unite-rails'
NeoBundle 'tpope/vim-rails'

" perl
NeoBundleLazy 'hotchpotch/perldoc-vim', { "autoload" : { "filetypes" : ["perl"] } }

NeoBundleLazy 'vim-perl/vim-perl', { "autoload" : { "filetypes" : ["perl"] } }


NeoBundleLazy 'vim-scripts/php.vim-html-enhanced', { "autoload" : { "filetypes" : ["php"] } }

" html
NeoBundleLazy 'othree/html5.vim', { "autoload" : { "filetypes" : ["html"] } }

" javascript
NeoBundle     'elzr/vim-json'
NeoBundleLazy 'pangloss/vim-javascript', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'othree/javascript-libraries-syntax.vim', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'maksimr/vim-jsbeautify', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'mattn/jscomplete-vim', { "autoload" : { "filetypes" : ["javascript"] } }
NeoBundleLazy 'matthewsimo/angular-vim-snippets', { "autoload" : { "filetypes" : ["javascript"] } }
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
NeoBundle     'lilydjwg/colorizer'
NeoBundleLazy 'JulesWang/css.vim', {'autoload':{'filetypes':['scss','css']}}
NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload':{'filetypes':['scss','css']}}
NeoBundleLazy 'csscomb/vim-csscomb', {'autoload':{'filetypes':['scss', 'css']}}
NeoBundleLazy 'cakebaker/scss-syntax.vim', {'autoload':{'filetypes':['scss']}}
NeoBundleLazy 'pasela/unite-webcolorname', {'autoload':{'filetypes':['scss', 'css', 'html']}}

" jade
NeoBundleLazy 'digitaltoad/vim-jade', {'autoload':{'filetypes':['jade']}}

" log
NeoBundleLazy 'vim-scripts/AnsiEsc.vim', {'autoload': {'mappings': ['<Plug>SaveWinPosn', '<Plug>RestoreWinPosn'], 'commands': ['DM', 'RWP', 'AnsiEsc', 'RM', 'SM', 'WLR', 'SWP']}}

"colorscheme
NeoBundle 'scwood/vim-hybrid'
NeoBundle 'miyakogi/seiya.vim'

" TweetVim
NeoBundle 'basyura/TweetVim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'basyura/bitly.vim'

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
let g:seiya_auto_enable=1

" カーソル行にアンダーラインを引く(color terminal)
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" Watchdogsのエラー箇所のハイライトをいい感じにする
execute 'highlight qf_error_ucurl ctermfg=167 ctermbg=52 gui=undercurl guifg=#cc6666 guibg=#5f0000 guisp=Red'
let g:hier_highlight_group_qf  = 'qf_error_ucurl'
execute 'highlight qf_warning_ucurl ctermfg=109 ctermbg=24 gui=underline guifg=#8abeb7 guibg=#005f5f guisp=Cyan'
let g:hier_highlight_group_qfw = 'qf_warning_ucurl'

" エラー箇所の行番号左にSignを表示
" 行全体のハイライトはなし、SignのみErrorMsg（赤色）にする
let g:qfsigns#Config = {'id': '5051', 'name': 'QFSign'}
sign define QFSign linehl=NONE texthl=ErrorMsg text=>>

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
  return winwidth(0) > 70 ? (&fileformat) : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
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
      \       'cmdopt' : '-R -S -a -D'
      \   }
let g:quickrun_config['coffee/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/coffeelint',
      \   }
let g:quickrun_config['jade/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/jade'
      \   }
let g:quickrun_config['css/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/csslint'
      \   }
let g:quickrun_config['javascript/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/eslint',
      \       'cmdopt' : '--fix'
      \  }
let g:quickrun_config['javascript.jsx/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/eslint',
      \       'cmdopt' : '--fix'
      \  }
let g:quickrun_config['markdown/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/textlint'
      \  }
let g:quickrun_config['sh/watchdogs_checker'] = {
      \       'command' : 'shellcheck', 'cmdopt' : '-f gcc',
      \       'type': 'watchdogs_checker/shellcheck'
      \  }
let g:quickrun_config['vim/watchdogs_checker'] = {
      \     'type': executable('vint') ? 'watchdogs_checker/vint' : '',
      \     'command'   : 'vint',
      \     'exec'      : '%c %o %s:p' ,
      \   }
let g:quickrun_config['json/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/jsonlint',
      \       'cmdopt' : '-i'
      \  }

" execute
let g:quickrun_config['html'] = { 'command' : 'open', 'exec' : '%c %s', 'outputter': 'browser' }

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
"let g:neocomplete#auto_completion_start_length    = 2
let g:neocomplete#enable_ignore_case              = 1
" let g:neocomplete#enable_smart_case               = 1
let g:neocomplete#enable_cursor_hold_i            = 1
" let g:neocomplete#enable_camel_case               = 1
" let g:neocomplete#enable_fuzzy_completion         = 1
let g:neocomplete#use_vimproc                     = 1
let g:neocomplete#lock_buffer_name_pattern        = '\*ku\*'

" rsense
let g:neocomplete#force_omni_input_patterns = {
      \   'ruby' : '[^. *\t]\.\|\h\w*::',
      \   'rails' : '[^. *\t]\.\|\h\w*::',
      \   'rspec' : '[^. *\t]\.\|\h\w*::',
      \   'eruby' : '[^. *\t]\.\|\h\w*::',
      \   'ruby.rails' : '[^. *\t]\.\|\h\w*::',
      \   'ruby.rspec' : '[^. *\t]\.\|\h\w*::',
      \   'eruby.html' : '[^. *\t]\.\|\h\w*::'
      \}

let g:rsenseUseOmniFunc = 1

let g:neocomplete#sources#dictionary#dictionaries = {
\   'ruby': $HOME . '/.vim/bundle/dicts/ruby.dict',
\ }

"for turn_vim
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

" rails
"   autocmd!
"   autocmd BufEnter * if exists("b:rails_root") | NeoCompleteSetFileType ruby.rails | endif
"   autocmd BufEnter * if (expand("%") =~ "_spec\.rb$") || (expand("%") =~ "^spec.*\.rb$") | NeoCompleteSetFileType ruby.rspec | endif
" augroup END

" enable ruby & rails snippet only rails file
function! s:RailsSnippet()
  if exists('b:rails_root') && (&filetype == 'ruby')
    set ft=ruby.rails
  endif
endfunction

function! s:RSpecSnippet()
  if (expand('%') =~ "_spec\.rb$") || (expand('%') =~ "^spec.*\.rb$")
    set ft=ruby.rspec
  endif
endfunction

augroup rails_snippet
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
nnoremap <silent> <C-s> :OverCommandLine<CR>%s/<C-r><C-w>//<Left>
vnoremap <silent> <C-s> y:OverCommandLine<CR>%s/<C-r>"//<Left>
" カーソル下の単語をハイライト付きで置換
nnoremap sb :overcommandline<CR>%s/<C-r><C-w>//<Left>
" コピーした文字列をハイライト付きで置換
nnoremap sbp y:OverCommandLine<CR>%s/<C-r>=substitute(@0, '/', '/', 'g')<CR>//<Left>

cnoreabb <silent><expr>s getcmdtype()==':' && getcmdline()=~'^s' ? 'OverCommandLine<CR><C-u>%s/<C-r>=get([], getchar(0), '')<CR>' : 's'

" <C-v> 時に特殊文字を挿入
OverCommandLineMap <C-v> <C-q>

"" {{{Unite
" " インサートモードで開始
let g:unite_enable_start_insert=1
" 最近のファイルの個数制限
let g:unite_source_file_mru_limit           = 1000
let g:unite_source_file_mru_filename_format = ''
" file_recのキャッシュ
let g:unite_source_rec_max_cache_files = 50000
" let g:unite_source_rec_min_cache_files = 100

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
  let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
endif
call unite#filters#sorter_default#use(['sorter_ftime*'])
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source('file_rec, file_rec/git, grep/git, buffer, file', 'sorters', 'sorter_selecta')

" 画像はキャッシュしない
call unite#custom#source('grep/git',        'ignore_pattern', '\.png\|.gif\|.jpeg\|.jpg\')
call unite#custom#source('source/buffer:?', 'ignore_pattern', '\.png\|.gif\|.jpeg\|.jpg\')
call unite#custom#source('file_rec/async',  'ignore_pattern', '\.png\|.gif\|.jpeg\|.jpg\')

set wildignore=*.o,*.obj,*.la,*.lo,*.so,*.pyc,*.pyo,*.jpg,*.jpeg,*.png,*.gif

call unite#custom#source('file_rec/git, grep/git, buffer, file_rec/async', 'ignore_globs', split(&wildignore, ','))

" タブが存在しているときはタブ移動
let action = {
\   'description' : 'tab drop',
\   'is_selectable' : 1,
\ }
function! action.func(candidates) "{{{
    for l:candidate in a:candidates
        call unite#util#smart_execute_command('tab drop', l:candidate.action__path)
    endfor
endfunction "}}}
call unite#custom_action('openable', 'tabdrop', action)
unlet action

call unite#custom_default_action('file', 'tabdrop')

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

  " "スペースキーと]キーでtagsを検索
  vnoremap <silent> [unite]] :<C-u>UniteWithCursorWord -immediately tag:<C-r><C-W> <CR>
  nnoremap <silent> [unite]] :<C-u>UniteWithCursorWord -immediately tag:<C-r><C-W> <CR>
  augroup unite_jump
    autocmd!
    autocmd BufEnter *
          \   if empty(&buftype)
          \|      nnoremap <buffer> [unite]t :<C-u>Unite jump<CR>
          \|  endif
  augroup END

  ""tweet vimのアカウントを切り替え
  nnoremap <silent> [unite]s :<C-u>Unite<space> tweetvim/account<CR>

  ""スペースキーとpキーでヒストリ/ヤンクを表示
  nnoremap <silent> [unite]p :<C-u>Unite<Space> yankround<CR>
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
  " grep検索
  nnoremap <silent> [unite]G  :<C-u>UniteWithProjectDir grep:. -buffer-name=search-buffer <CR>
  " カーソル位置の単語をgrep検索
  nnoremap <silent> [unite]cG :<C-u>UniteWithProjectDir grep:. -buffer-name=search-buffer <CR> <C-R><C-W>
  " git-grep
  nnoremap <silent> [unite]g  :<C-u>Unite grep/git:/ -buffer-name=search-buffer <CR>
  nnoremap <silent> [unite]cg :<C-u>Unite grep/git:/ -buffer-name=search-buffer <CR> <C-r><C-W>

  " grep検索結果の再呼出
  nnoremap <silent> [unite]r  :<C-u>UniteResume search-buffer <CR>
  " " bookmark
  nnoremap <silent> [unite]B :<C-u>Unite bookmark<CR>

  nnoremap <silent> [unite]<CR> :<C-u>Unite file_rec/git -buffer-name=search-buffer <CR>

  ""unite-rails
  noremap <silent> [unite]ec :<C-u>Unite rails/controller<CR>
  noremap <silent> [unite]em :<C-u>Unite rails/model<CR>
  noremap <silent> [unite]ev :<C-u>Unite rails/view<CR>
  noremap <silent> [unite]eh :<C-u>Unite rails/helper<CR>
  noremap <silent> [unite]es :<C-u>Unite rails/stylesheet<CR>
  noremap <silent> [unite]ej :<C-u>Unite rails/javascript<CR>
  noremap <silent> [unite]er :<C-u>Unite rails/route<CR>
  noremap <silent> [unite]eg :<C-u>Unite rails/bundled_gem<CR>
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
  "ctrl+oでタブで開く
  nnoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
  inoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
endfunction
"" }}}

" markdownの設定
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_frontmatter=1

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

"gitgutter
let g:gitgutter_diff_args = '-w'
nnoremap <silent> ,gg :<C-u>GitGutterToggle<CR>
nnoremap <silent> ,gh :<C-u>GitGutterLineHighlightsToggle<CR>

"previm
augroup PrevimSettings
  autocmd!
  autocmd  FileType markdown call s:loadPrevimSetting()
augroup END

function! s:loadPrevimSetting()
  let g:previm_enable_realtime = 1
  nmap <Leader>r :PrevimOpen<CR>
endfunction

"gista
let g:gista#github_user = 'iberianpig'
let g:gista#post_private = 1

" for open-browser plugin
nmap gx <Plug>(openbrowser-smart-search)
vmap gx :<C-u>OpenBrowserSearch <C-r><C-w> <CR>
nmap gd :<C-u>OpenBrowserSearch -devdocs <C-r><C-w> <CR>
vmap gd y:<C-u>OpenBrowserSearch -devdocs <C-R>"<CR> 

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
nmap <silent> <Leader>i <Plug>IndentGuidesToggle
augroup indent_guides_color
  autocmd!
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=236
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
augroup END

let g:rspec_command = 'Dispatch rspec --format progress --no-profile {spec}'

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

highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
highlight link multiple_cursors_visual Visual

" easy-align
"" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"vim-unified-diff
set diffexpr=unified_diff#diffexpr()

" integrate vim with ranger
function! RangerExplorer(path)
  exec 'silent !ranger --choosefile=/tmp/vim_ranger_current_file ' . a:path
  if filereadable('/tmp/vim_ranger_current_file')
    exec 'edit ' . system('cat /tmp/vim_ranger_current_file')
    call system('rm /tmp/vim_ranger_current_file')
  endif
  redraw!
endfunction

function! RangerOpenProjectRootDir()
  let root_dir = unite#util#path2project_directory(expand('%'))
  :call RangerExplorer(root_dir)
endfunction

function! RangerOpenCurrentDir() abort
  let current_dir = expand('%:p:h')
  :call RangerExplorer(current_dir)
endfunction

function! RangerOpenWithEdit(path) abort
  if !isdirectory(a:path)
    return
  endif
  bw!
  :call RangerExplorer(a:path)
  :filetype detect
endfunction

nnoremap <silent>[unite]c :call RangerOpenCurrentDir()<cr>
nnoremap <silent>[unite]f :call RangerOpenProjectRootDir()<cr>

augroup open_with_ranger
  autocmd!
  let g:loaded_netrwPlugin = 'disable'
  autocmd BufEnter * silent call RangerOpenWithEdit(expand("<amatch>"))
augroup END

"TweetVim
let g:tweetvim_display_icon=1
let g:tweetvim_async_post=1
let g:tweetvim_display_username=1
let g:tweetvim_tweet_per_page=20
let g:tweetvim_say_insert_account=1
nnoremap <leader>t :<C-u>TweetVimSay<CR>

" vim-auto-save
let g:auto_save_silent = 1  " do not display the auto-save notification
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option

" read onlyの場合は自動保存しない
function! s:auto_save_detect() abort
  if &readonly
    let g:auto_save = 0 " 自動保存しない
  else
    let g:auto_save = 1 " 自動保存
  end
endfunction

augroup switch_auto_save
  autocmd!
  au BufEnter * call s:auto_save_detect()
augroup END

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
