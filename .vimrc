scriptencoding utf-8

filetype off
filetype plugin indent off

" autocmdのリセット
autocmd!
set number     " 行番号を表示する
set cursorline " カーソル行の背景色を変える

" カーソルの設定
" ref: https://stackoverflow.com/a/42118416
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

augroup set_cursorline
  autocmd!
  autocmd InsertLeave * set cursorline
  autocmd InsertEnter * set nocursorline

  " reset the cursor on start (for older versions of vim, usually not required)
  autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

set laststatus=2   " ステータス行を常に表示
set cmdheight=1    " メッセージ表示欄を2行確保
set showmatch      " 対応する括弧を強調表示
set matchpairs+=「:」,『:』,（:）,【:】,《:》,〈:〉,［:］,‘:’,“:”,`:`

set helpheight=998 " ヘルプを画面いっぱいに開く

" set synmaxcol=300  " 長い行の場合、syntaxをoffにする 既定では3000
set list           " 不可視文字を表示
set listchars=tab:▸\ ,nbsp:%,trail:_ " 不可視文字の表示記号指定
set t_Co=256 "ターミナルで256色利用
set iskeyword+=?,!,-,@-@ "?,!,@hogeなどをキーワードとする

" " Don't screw up folds when inserting text that might affect them, until
" " leaving insert mode. Foldmethod is local to the window. Protect against
" " screwing up folding when switching between windows.
" augroup switch_folding_method
"   autocmd!
"   autocmd InsertEnter *
"     \ if !exists('w:last_fdm') |
"     \   let w:last_fdm=&foldmethod |
"     \   setlocal foldmethod=manual |
"     \ endif
"   autocmd InsertLeave,WinLeave *
"     \ if exists('w:last_fdm') |
"     \   let &l:foldmethod=w:last_fdm |
"     \   unlet w:last_fdm |
"     \ endif
" augroup END
set nofoldenable    " disable folding

" augroup vimrc-highlight
  " autocmd!
"   autocmd Syntax off if 10000 > line('$') | syntax sync minlines=1000 | endif
" augroup END

" Charset, Line ending -----------------

set fileformats=unix,dos,mac  " LF, CRLF, CR
" set ambiwidth=double  " UTF-8の□や○でカーソル位置がずれないようにする

" function! s:detect_terminal()
"   if &buftype ==# 'terminal' && &filetype ==# ''
"     set filetype=terminal
"   endif
" endfunction
"
" function! s:set_terminal_option()
"    " ここに :terminal のバッファ固有の設定を記述する
"    set ambiwidth=single  " ズレが発生するので元に戻す
" endfunction
"
" function! s:unset_terminal_option()
"    " ここに :terminalから戻った時に設定を戻す
"    set ambiwidth=double  " UTF-8の□や○でカーソル位置がずれないようにする
" endfunction
"
"
" augroup toggle_terminal_option
"     autocmd!
"    " BufNew の時点では 'buftype' が設定されていないので timer イベントでごまかすなど…
"     autocmd BufNew * call timer_start(0, { -> s:detect_terminal() })
"     autocmd BufWinEnter,FileType * call s:unset_terminal_option()
"     autocmd BufWinEnter,FileType terminal call s:set_terminal_option()
" augroup END

" set nospell

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
  set updatetime=1000
  " autocmd WinEnter,CursorHold * if mode() !=# "c" | checktime | endif " command line はmode()でnを返してしまう
  autocmd WinEnter,CursorHold * if !bufexists("[Command Line]") && !bufexists("[コマンドライン]") | checktime | endif
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

" vを二回で行末まで選択
vnoremap v $h

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

" ESC ESC でハイライトを消す
nnoremap <silent> <ESC><ESC> :call ClearHighlight()<CR>
"
function! ClearHighlight() abort
  call popup_clear() "ポップアップのクリア
endfunction

" quickhlのハイライトをオフにする
nnoremap <silent> <ESC><ESC><ESC> :call ClearQuickhl()<CR>

function! ClearQuickhl() abort
  call quickhl#manual#reset() " quickhlのハイライトをオフにする
  call popup_clear() "ポップアップのクリア
endfunction

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

"tab/indentの設定
set shellslash
set expandtab                         " タブ入力を複数の空白入力に置き換える
set tabstop=2                         " 画面上でタブ文字が占める幅
set shiftwidth=2                      " 自動インデントでずれる幅
set softtabstop=2                     " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set shiftround                        " インデント操作がshiftwidthに揃うように丸める
set autoindent                        " 改行時に前の行のインデントを継続する
set smartindent                       " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set indentkeys=!^F,o,O,0<Bar>,0=where " 自動インデントを発動させるタイミングを設定する

" signの幅を予め確保しておく
set signcolumn=yes

" 新しいウィンドウを下に開く
set splitbelow
" 新しいウィンドウを右に開く
set splitright

" 日本語ヘルプを利用する
set helplang=ja,en

".vimrcの編集用
nnoremap <Space>. :<C-u>tab drop $HOME/dotfiles/.vimrc<CR>
nnoremap R :<C-u>source $HOME/.vimrc<CR>

" q: のタイポ抑制
nnoremap q: :q
" 英字キーボードのタイプミス対策
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

" terminal mode
" " ノーマルモード(コピーできるようにする)
tnoremap <C-w>[ <C-w>N

augroup add_syntax_highlight
  autocmd!
  "シンタックスハイライトの追加
  autocmd BufNewFile,BufRead *.json.jbuilder            set filetype=ruby
  autocmd BufNewFile,BufRead Gemfile*,*.gemfile.*          set filetype=ruby
  autocmd BufNewFile,BufRead *.thor                     set filetype=ruby
  autocmd BufNewFile,BufRead *.erb                      set filetype=eruby
  autocmd BufNewFile,BufRead *.slim                     set filetype=slim
  autocmd BufNewFile,BufRead *json.jb                   set filetype=ruby
  " autocmd BufNewFile,BufRead *.scss                     set filetype=scss.css
  autocmd BufNewFile,BufRead *.coffee                   set filetype=coffee
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
  autocmd BufNewFile,BufRead *.vtl                      set filetype=velocity
  autocmd BufRead,BufNewFile *.ts                       set filetype=typescript
augroup END

" set re=1

set runtimepath+=~/.vim/ftplugin/

" let g:ruby_path = system('echo $HOME/.rbenv/shims')

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
Plug 't9md/vim-quickhl'

" 検索
Plug 'haya14busa/incsearch.vim'

" 括弧補完
" Plug 'cohama/lexima.vim'

" 補完系

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'prabirshrestha/asyncomplete-neosnippet.vim'

Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-neosnippet'

" Plug 'yami-beta/asyncomplete-omni.vim'
" Plug 'Shougo/neco-syntax'
" Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
Plug 'htlsne/asyncomplete-look'

Plug 'github/copilot.vim'

" deno
Plug 'vim-denops/denops.vim'
" Plug 'yuki-yano/fuzzy-motion.vim'
" Plug 'yuki-yano/denops-open-http.vim'

" Plug 'skanehira/denops-gh.vim'

Plug 'prettier/vim-prettier', {
 \ 'do': 'yarn install',
 \ 'branch': 'release/1.x',
 \ 'for': [
   \ 'javascript',
   \ 'typescript',
   \ 'css',
   \ 'less',
   \ 'scss',
   \ 'json',
   \ 'graphql',
   \ 'markdown',
   \ 'vue',
   \ 'lua',
   \ 'php',
   \ 'python',
   \ 'ruby',
   \ 'html',
   \ 'swift' ] }


" %で閉じタグに飛ぶ
Plug 'tmhedberg/matchit'

Plug 'thinca/vim-quickrun'

" quickfixのエラーメッセージを下部に表示する
Plug 'dannyob/quickfixstatus', {'on': ['QuickfixStatusDisable', 'QuickfixStatusEnable']}

Plug 'anyakichi/vim-qfutil'

" " " 非同期処理でLinterを動かす
" Plug 'w0rp/ale'
"
" " " aleの結果をlightlineに出力
" Plug 'maximbaz/lightline-ale'

" テストランナー
Plug 'janko-m/vim-test'
Plug 'jonleighton/vim-test-vimterminal-enhanced'

" インデントの可視化
Plug 'nathanaelkane/vim-indent-guides', {'on': ['IndentGuidesEnable', 'IndentGuidesToggle', 'IndentGuidesDisable', ]}

" " p/Pで貼り付け先のインデントに合わせる
" Plug 'deris/vim-pasta'

" Git/SVNの差分箇所をマークで表示
Plug 'mhinz/vim-signify'

" Git diff用
Plug 'tpope/vim-fugitive', {'on': ['Gdiff']}

" PJ毎の稼働時間を記録
Plug 'wakatime/vim-wakatime'

" 自動保存
" Plug 'vim-scripts/vim-auto-save'
Plug '907th/vim-auto-save'

" " 再帰的なfジャンプ
" Plug 'rhysd/clever-f.vim'

" Surround
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'kana/vim-textobj-line'
Plug 'fvictorio/vim-textobj-backticks'
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-operator-surround'
Plug 'tyru/operator-camelize.vim'

Plug 'aymericbeaumet/vim-symlink' | Plug 'moll/vim-bbye' " optional dependency

" Rename
Plug 'qpkorr/vim-renamer', { 'on': 'Renamer'}

" editorconfig
Plug 'editorconfig/editorconfig-vim', { 'on': ['EditorConfigReload']}

" cd project-root
Plug 'airblade/vim-rooter'

" grammar checker
Plug 'rhysd/vim-grammarous'

""Markdown
" syntax
Plug 'rcmdnk/vim-markdown',  { 'for': ['markdown'] } | Plug 'godlygeek/tabular' | Plug 'joker1007/vim-markdown-quote-syntax'
" 日本語の句読点をTextObjectの区切りと扱う
Plug 'deton/jasentence.vim', { 'for': ['markdown'] }
" マークダウンをブラウザ上でHTMLレンダリング
Plug 'rhysd/vim-gfm-syntax', { 'for': 'markdown' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'plantuml', 'vim-plug']}

Plug 'mattn/vim-maketable' ", { 'for': 'markdown' }

"" Rails
" Rails用の規約ベースのコードジャンプ, b:rails_rootを定義
Plug 'tpope/vim-rails' ", { 'for': ['ruby'] }

" Ruby用の規約ベースのコードジャンプ
Plug 'tpope/vim-rake', { 'for': ['ruby'] } | Plug 'tpope/vim-projectionist', { 'for': ['ruby'] }

" slimのsyntax highlight
Plug 'slim-template/vim-slim', { 'for': ['slim'] }

" vim-ruby
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby'] }

" heredocのハイライト
Plug 'joker1007/vim-ruby-heredoc-syntax', { 'for': ['ruby'] }

"" Golang
Plug 'benmills/vimux' | Plug 'sebdah/vim-delve', { 'for': ['go'] }
" Plug 'mattn/vim-goimports', { 'for': ['go'] }
" Plug 'mattn/vim-gotmpl', { 'for': ['go'] }
Plug 'mattn/vim-gomod', { 'for': ['go'] }

"" python
Plug 'Glench/Vim-Jinja2-Syntax'

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
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'

"" typescript
Plug 'leafgarland/typescript-vim', {'for':['typescript', 'tsx']}
" Plug 'Quramy/tsuquyomi', {'for':['typescript', 'tsx']}
Plug 'ianks/vim-tsx', {'for':['typescript', 'tsx']}

" graphql
Plug 'jparise/vim-graphql',  {'for':['javascript', 'html', 'graphql']}

" vtl
Plug 'lepture/vim-velocity', { 'for':['velocity', 'vtl'] }

" toml
Plug 'cespare/vim-toml', { 'for': ['toml'] }

" PlantUML
Plug 'aklt/plantuml-syntax', { 'for': ['plantuml'] }

" css
" Plug 'lilydjwg/colorizer'
" Plug 'JulesWang/css.vim',         {'for':['scss', 'css']}
" Plug 'hail2u/vim-css3-syntax',    {'for':['scss', 'css']}
" Plug 'csscomb/vim-csscomb',       {'for':['scss', 'css']}
" Plug 'cakebaker/scss-syntax.vim', {'for':['scss']}

" log
Plug 'powerman/vim-plugin-AnsiEsc'

" colorscheme
Plug 'habamax/vim-habamax'
Plug 'w0ng/vim-hybrid'
Plug 'morhetz/gruvbox'

Plug 'miyakogi/seiya.vim'

" help
Plug 'vim-jp/vimdoc-ja'
Plug 'KabbAmine/zeavim.vim'

" readline lik keybindings
Plug 'tpope/vim-rsi'

" Abbreviation, Substitution, and Capitalization
Plug 'tpope/vim-abolish'

"create vim plugin's skeleton
Plug 'mopp/layoutplugin.vim', { 'on' : 'LayoutPlugin'}

"unite like serching interface
Plug 'junegunn/fzf'
Plug 'pbogut/fzf-mru.vim'

"solidity
Plug 'tomlion/vim-solidity'

" nginx
Plug 'chr4/nginx.vim'

" ansible
Plug 'pearofducks/ansible-vim', { 'do': 'cd ./UltiSnips; ./generate.py'  }

" terraform
Plug 'hashivim/vim-terraform'

Plug 'direnv/direnv.vim'

" protobuf
Plug 'uarun/vim-protobuf'

Plug 'rbtnn/vim-ambiwidth'

" ローカル管理のPlugin
Plug '~/.ghq/github.com/iberianpig/tig-explorer.vim' | Plug 'rbgrouleff/bclose.vim'
Plug '~/.ghq/github.com/iberianpig/ranger-explorer.vim'
Plug '~/.ghq/github.com/iberianpig/ruby_hl_lvar.vim', { 'for' : ['ruby']   }

" Initialize plugin system
call plug#end()

" Required:
filetype plugin indent on
syntax on

" ...
" 読み込んだプラグインの設定
" ...

set background=dark "暗めの背景
"
" " colorschme
"
" " " " hybrid
colorscheme hybrid
let g:seiya_auto_enable=1

" " gruvbox
" colorscheme gruvbox

" カーソル行にアンダーラインを引く(color terminal)
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '_'
let g:signify_sign_delete_first_line = '-'
let g:signify_sign_change            = '!'
let g:signify_sign_change_delete     = g:signify_sign_change . g:signify_sign_delete_first_line

" lightline {{{
" available colorscheme:
" wombat, solarized, powerline, jellybeans, Tomorrow,
" Tomorrow_Night, Tomorrow_Night_Blue, Tomorrow_Night_Eighties,
" PaperColor, seoul256, landscape and 16color
let g:lightline = {
    \ 'colorscheme': 'Tomorrow_Night',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], [ 'ctrlpmark'], [ 'currentfunction' ] ],
    \   'right': [[ 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ], ['lsp_errors', 'lsp_warnings', 'lsp_ok'], ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]]
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
    \   'currentworkingdir': 'CurrentWorkingDir',
    \   'percent':           'MyPercent',
    \   'lineinfo':          'MyLineInfo',
    \ },
    \ 'component_expand':    {
    \  'linter_checking': 'lightline#ale#checking',
    \  'linter_warnings': 'lightline#ale#warnings',
    \  'linter_errors': 'lightline#ale#errors',
    \  'linter_ok': 'lightline#ale#ok',
    \  'lsp_warnings': 'LightlineLSPWarnings',
    \  'lsp_errors':   'LightlineLSPErrors',
    \  'lsp_ok':       'LightlineLSPOk',
    \ },
    \ 'component_type':      {
    \     'linter_checking': 'left',
    \     'linter_warnings': 'warning',
    \     'linter_errors': 'error',
    \     'linter_ok': 'left',
    \     'lsp_warnings': 'warning',
    \     'lsp_errors':   'error',
    \     'lsp_ok':       'middle',
    \ },
    \ 'tabline':             {
    \   'left':              [ [ 'tabs' ] ],
    \   'right':             [ [ 'currentworkingdir' ] ],
    \ },
    \}


function! MyModified()
  return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyPercent()
  return (100 * line('.') / line('$')) . '%'
endfunction

function! MyLineInfo()
  return printf('%3d:%-2d', line('.'), col('.'))
endfunction

function! MyReadonly()
   return &readonly ? 'RO' : ''
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
  return winwidth(0) > 70 ? lightline#mode() : ''
endfunction

function! CurrentWorkingDir()
  return fnamemodify(getcwd(),':')
endfunction

"}}}

" enable ruby & rails snippet only rails file
function! s:RailsSnippet()
  if exists('b:rails_root') && (&filetype ==# 'ruby')
    :NeoSnippetSource ~/.vim/snippets/rails.snip
  endif
endfunction

function! s:RSpecSnippet()
  if (expand('%') =~# '_spec\.rb$') || (expand('%') =~# '^spec.*\.rb$')
    :NeoSnippetSource ~/.vim/snippets/rspec.snip
  endif
endfunction

function! s:MinitestSnippet()
  if (expand('%') =~# '_test\.rb$') || (expand('%') =~# '^test.*\.rb$')
    :NeoSnippetSource ~/.vim/snippets/minitest.snip
  endif
endfunction

augroup rails_snippet
  autocmd!
  au BufEnter * call s:RailsSnippet()
  au BufEnter * call s:RSpecSnippet()
  au BufEnter * call s:MinitestSnippet()
augroup END

" vim-rails
let g:rails_projections = {
      \  "app/controllers/*_controller.rb": {
      \    "affinity": "controller",
      \    "template": [
      \      "class {camelcase|capitalize|colons}Controller < ApplicationController",
      \      "end"
      \    ],
      \    "type": "controller",
      \    "test": [
      \      "spec/requests/{}_spec.rb",
      \      "spec/controllers/{}_controller_spec.rb",
      \    ],
      \    "alternate": [
      \      "spec/requests/{}_spec.rb",
      \      "spec/controllers/{}_controller_spec.rb",
      \    ],
      \  },
      \  "spec/requests/*_spec.rb": {
      \    "affinity": "controller",
      \    "alternate": [
      \      "app/controllers/{}_controller.rb",
      \    ],
      \    "controller": [
      \      "app/controllers/{}_controller.rb",
      \    ],
      \  },
      \  "app/services/*.rb": {
      \    "affinity": "service",
      \    "template": [
      \      "class {camelcase|capitalize|colons}",
      \      "end"
      \    ],
      \    "type": "services",
      \    "test": [
      \      "spec/services/{}_spec.rb",
      \    ],
      \    "alternate": [
      \      "spec/services/{}_spec.rb",
      \    ],
      \  },
      \}

" Projectionist globals
let g:projectionist_heuristics = {
      \  "shard.yml|shards.yml": {
      \    "src/*.cr": {"alternate": "spec/{}_spec.cr"},
      \    "spec/*_spec.cr": {"type": "spec", "alternate": "src/{}.cr"},
      \  },
      \ "Gemfile.lock|Rakefile": {
      \    "lib/**/*.rb": {"alternate": "spec/{}_spec.rb"},
      \    "spec/**/*_spec.rb": {"type": "spec", "alternate": "lib/{}.rb"},
      \  },
      \ "autoload/*.vim": {
      \    "plugin/*.vim": {"type": "plugin"},
      \    "autoload/*.vim": {"type": "autoload"},
      \    "doc/*.txt": {"type": "doc"},
      \    "README.md": {"type": "doc"}
      \  },
      \}

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
nnoremap <silent> <C-s> :OverCommandLine<CR>%s;<C-r><C-w>;;<Left><C-r><C-w>
vnoremap <silent> <C-s> y:OverCommandLine<CR>%s;<C-r>";;<Left><C-r>"
vnoremap <silent> :s :OverCommandLine<CR>s;;<Left>
" カーソル下の単語をハイライト付きで置換
nnoremap s :OverCommandLine<CR>%s;<C-r><C-w>;;<Left>
" コピーした文字列をハイライト付きで置換
vnoremap s y:OverCommandLine<CR>%s;<C-r>=substitute(@0, ';', ';', 'g')<CR>//<Left>

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
let g:fzf_layout = { 'down': '~25%' }

"" fzf-filemru
let g:fzf_filemru_bufwrite=1


nnoremap  [fzf]  <Nop>
nnoremap <Space> [fzf]
nmap <Space> [fzf]
vnoremap <Space> <Nop>
vmap <Space> [fzf]

" スペースキーとaキーでカレントディレクトリを表示
" nnoremap <expr> <silent> [fzf]a ":Files<CR>".expand('%:h')

" スペースキーとmキーでプロジェクト内で最近開いたファイル一覧を表示
let g:fzf_mru_relative = 1
nnoremap <silent> [fzf]m :FZFMru<cr>
nnoremap <silent> [fzf]M :History<cr>

nnoremap <silent> [fzf]<CR> :GitFiles<CR>

" "スペースキーとbキーでバッファを表示
" nnoremap <silent> [fzf]b :Buffers<CR>
nnoremap <silent> [fzf]b :Buffers<cr>

nnoremap <silent> [fzf]h :<C-u>Helptags<CR>

" ghqで管理しているリポジトリを開く
nnoremap <silent> [fzf]r :call fzf#run(fzf#wrap({'source': 'ghq list --full-path', 'sink': 'tabnew' }))<CR>

" コマンドを検索
nnoremap <silent> [fzf]: :<C-u>Commands<CR>
nnoremap <silent> [fzf]; :<C-u>Commands<CR>

" カーソル下のパスを開く"
nnoremap <silent> [fzf] gF

" 現在のファイルから行を検索
nnoremap <silent> [fzf]/ :Lines<CR>

" markdownの設定
" see /usr/share/vim/vim80/syntax/*.vim
let g:markdown_fenced_languages = ['ruby', 'json', 'vim', 'sh', 'javascript']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0

" markdown-preview
let g:mkdp_filetypes = ['markdown', 'plantuml']

augroup LeaderR
  autocmd!
  autocmd BufEnter * call s:loadLeaderRMapping()
augroup END

" Switch QuickRun / MarkdownPreview
function! s:loadLeaderRMapping()
  if index(g:mkdp_filetypes, &ft) < 0
    nnoremap <Leader>r :QuickRun<CR>
    vnoremap <Leader>r :QuickRun<CR>
  else
    nnoremap <Leader>r :MarkdownPreview<CR>
  endif
endfunction

" quickrun
" let ruby_bundle_hook = {'kind': 'hook', 'name': 'ruby_bundle'}
" function ruby_bundle_hook.on_normalized(session, context) abort
"   if getcwd() !=# $HOME && isdirectory('.bundle')
"     let a:session.config.exec =
"          \   map(copy(a:session.config.exec), 's:bundle_exec(v:val)')
"   endif
" endfunction
" function s:bundle_exec(cmd) abort
"   return substitute(a:cmd, '\ze%c', 'bundle exec ', '')
" endfunction
" call quickrun#module#register(ruby_bundle_hook, 1)

augroup quickrun
  autocmd!
  autocmd FileType quickrun AnsiEsc
augroup END

let g:quickrun_config = get(g:, 'quickrun_config', {})

let g:quickrun_config._ = {
     \ 'runner'    : 'terminal',
     \   'hook/close_quickfix/enable_hook_loaded' : 1,
     \   'hook/close_quickfix/enable_success'     : 1,
     \   'hook/close_buffer/enable_hook_loaded'   : 1,
     \   'hook/close_buffer/enable_failure'       : 1,
     \   'hook/inu/enable'                        : 1,
     \   'hook/inu/wait'                          : 1,
     \   'outputter'                              : 'multi:buffer:quickfix',
     \   'outputter/buffer/split'                 : 'botright',
     \   'outputter/quickfix/open_cmd'            : 'copen',
     \ }

	let g:quickrun_config.html = {
        \ "command" : "cat",
        \ "outputter" : "browser",
        \}
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
     \   'alc': {
     \     'url': 'http://eow.alc.co.jp/search?q=%s',
     \   },
     \ }

" デフォルトサイト
let g:ref_source_webdict_sites.default = 'ej'

" 出力に対するフィルタ
" 最初の数行邪魔なので削除
" function! g:ref_source_webdict_sites.je.filter(output)
"   " return join(split(a:output, "\n")[60 :], "\n")
" endfunction

" function! g:ref_source_webdict_sites.ej.filter(output)
"   " return join(split(a:output, "\n")[88 :], "\n")
" endfunction

call altercmd#load()
CAlterCommand ej Ref webdict ej
CAlterCommand je Ref webdict je

nnoremap ga :<C-u>ej <C-R>"<CR>
vnoremap ga y:<C-u>ej <C-R>"<CR>

" for open-browser plugin
" nmap gx <Plug>(openbrowser-smart-search)
nnoremap gx :OpenBrowserSmartSearch -google <C-r><C-w> <CR>
vnoremap gx y:<C-u>OpenBrowserSmartSearch -google <C-R>"<CR>
nnoremap gd :<C-u>OpenBrowserSmartSearch -devdocs <C-r><C-w> <CR>
vnoremap gd y:<C-u>OpenBrowserSmartSearch -devdocs <C-R>"<CR>
nnoremap ga :<C-u>OpenBrowserSmartSearch -alc <C-R>"<CR>
vnoremap ga y:<C-u>OpenBrowserSmartSearch -alc <C-R>"<CR>
vnoremap gex y:<C-u>OpenBrowserSmartSearch -deepl_en <C-R>"<CR>
vnoremap gjx y:<C-u>OpenBrowserSmartSearch -deepl_ja <C-R>"<CR>

" reloadしたら消えてしまう
if !exists('g:openbrowser_search_engines')
  let g:openbrowser_search_engines = {
       \ 'googletranslate_en': 'https://translate.google.com/#ja/en/{query}',
       \ 'googletranslate_ja': 'https://translate.google.com/#en/ja/{query}',
       \ 'deepl_en': 'https://www.deepl.com/translator#ja/en/{query}',
       \ 'deepl_ja': 'https://www.deepl.com/translator#en/ja/{query}',
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
let g:indent_guides_exclude_filetypes = ['help']
nnoremap <silent> <Leader>ig :IndentGuidesToggle<CR>
augroup indent_guides_color
  autocmd!
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=236
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=238
augroup END

" vim-test
nnoremap <silent> <leader>t :TestNearest<CR>
nnoremap <silent> <leader>T :TestFile<CR>
nnoremap <silent> <leader>a :TestSuite<CR>
nnoremap <silent> <leader>l :TestLast<CR>
nnoremap <silent> <leader>g :TestVisit<CR>

" require 'yarn add global jest-vim-reporter'
let g:test#javascript#jest#options = '--reporters jest-vim-reporter'
let test#javascript#runner = 'jest'

let test#go#runner = 'gotest'

function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  unlet g:test#go#runner
endfunction

nnoremap <leader>b  :DlvToggleBreakpoint<CR>

nnoremap <silent> <leader>d  :call DebugNearest()<CR>

let g:delve_use_vimux = 1

" let test#ruby#rspec#options = {
" \ 'nearest': '--backtrace',
" \ 'file':    '--format documentation',
" \ 'suite':   '--tag ~slow',
"\}
"
" let test#ruby#minitest#options = {
" \ 'nearest': '--backtrace',
" \ 'file':    '--format documentation',
" \ 'suite':   '--tag ~slow',
"\}


" docker and rspec
" https://qiita.com/joker1007/items/4dbff328f39c11e732af
function! DockerTransformer(cmd) abort
  let cmd = a:cmd
  " echomsg 'original cmd:' . cmd
  let compose_option = ''

  "" debug
  " echomsg 'SPEC_COMPOSE_FILE:' . $SPEC_COMPOSE_FILE
  " echomsg 'SPEC_PROJECT_ROOT__GO:' . $SPEC_PROJECT_ROOT__GO
  " echomsg 'SPEC_CONTAINER__GO:' . $SPEC_CONTAINER__GO

  if $SPEC_COMPOSE_FILE !=# ''
    echomsg 1
    let compose_option = ' -f ' . $SPEC_COMPOSE_FILE
  endif
  if &filetype == 'ruby'
    if $SPEC_PROJECT_ROOT__RUBY !=# ''
      cd $SPEC_PROJECT_ROOT__RUBY
      let g:test#project_root = $SPEC_PROJECT_ROOT__RUBY
    endif
    if $SPEC_COMMAND__RUBY !=# ''
      let path = substitute(a:cmd, '.*rspec ', '', '')
      let cmd = substitute($SPEC_COMMAND__RUBY, 'rspec', 'rspec ' . path, '')
    endif
    if $SPEC_CONTAINER__RUBY !=# ''
      let cmd = 'docker compose' . compose_option . ' exec ' .  $SPEC_CONTAINER__RUBY . ' ' . cmd .' '
    endif
  endif
  if &filetype == 'go'
    if $SPEC_PROJECT_ROOT__GO !=# ''
      cd $SPEC_PROJECT_ROOT__GO
      let g:test#project_root = $SPEC_PROJECT_ROOT__GO
    endif
    if $SPEC_COMMAND__GO !=# ''
      let cmd = $SPEC_COMMAND__GO
    endif
    if $SPEC_CONTAINER__GO !=# ''
      let cmd = 'docker compose' . compose_option . ' exec ' . $SPEC_CONTAINER__GO . ' ' . cmd .' '
    endif
  endif
  " if cmd !=# a:cmd
  "   let g:dispatch_compilers[prefix] = ''
  "   echomsg prefix . cmd
  "   return  prefix . cmd
  " endif
  echomsg cmd
  return cmd
endfunction

" let test#ruby#rspec#executable = 'rspec'
let g:test#custom_transformations = {'docker': function('DockerTransformer')}
let g:test#transformation = 'docker'

let g:vim_json_syntax_conceal = 0

"caw
" <C-/> or <C-_> でコメントトグル
nmap <C-_> <Plug>(caw:hatpos:toggle)
vmap <C-_> <Plug>(caw:hatpos:toggle)

" easy-align
"" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

nnoremap [explorer] <Nop>
nmap , [explorer]
vnoremap , <Nop>
vmap , [explorer]
nnoremap [explorer]T :TigOpenCurrentFile<CR>
nnoremap [explorer]t :TigOpenProjectRootDir<CR>
nnoremap [explorer]g :TigGrep<CR>
""選択状態のキーワードで検索"
vnoremap [explorer]g y:TigGrep<CR>"<C-R>""

" 履歴から検索
nnoremap [explorer]r :TigGrepResume<CR>

nnoremap [explorer]G :Tig -G""<LEFT>
vnoremap [explorer]G y:Tig -G"<C-R>""

"" open tig blame with current file
nnoremap [explorer]b :TigBlame<CR>
nnoremap [explorer]B :Tig blame -M -C -C -C -w %<CR>

nnoremap [explorer]s :Tig status<CR>
nnoremap [explorer]y :Tig stash<CR>
" nnoremap [explorer]r :Tig refs<CR>

" switch diffthis/ignore all whitespace/diffoff
function! s:diffthis_reapply() abort
  if &diff
    if &diffopt =~# 'iwhiteall'
      echomsg 'diffoff!'
      windo setlocal diffopt-=iwhiteall
      diffoff!
    else
      echomsg 'iwhiteall'
      windo setlocal diffopt+=iwhiteall
    endif
  else
    echomsg 'diffthis'
    windo diffthis
  endif
endfunction

noremap <silent> [explorer]d :call <SID>diffthis_reapply()<CR>

" let g:tig_explorer_orig_tigrc='~/.tigrc'
let g:tig_explorer_keymap_edit_e  = 'e'
" let g:tig_explorer_keymap_edit    = '<C-o>'
" let g:tig_explorer_keymap_tabedit = '<C-t>'
" let g:tig_explorer_keymap_split   = '<C-s>'
" let g:tig_explorer_keymap_vsplit  = '<C-v>'

" let g:tig_explorer_keymap_commit_edit    = '<ESC>o'
" let g:tig_explorer_keymap_commit_tabedit = '<ESC>t'
" let g:tig_explorer_keymap_commit_split   = '<ESC>s'
" let g:tig_explorer_keymap_commit_vsplit  = '<ESC>v'
let g:tig_explorer_use_builtin_term = 0

" ranger-explorer
nnoremap [explorer]c :<C-u>RangerOpenCurrentFile<CR>
nnoremap [explorer]f :<C-u>RangerOpenProjectRootDir<CR>

" vim-auto-save
let g:auto_save_silent = 1  " do not display the auto-save notification
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option
let g:auto_save_events = ["CursorHold", "InsertLeave", "TextChanged"]

" 自動保存の有効・無効の設定
function! s:auto_save_detect() abort
  " read onlyの場合は自動保存しない"
  " filenameがResultの場合は自動保存しない(dbext.vimで作られる一時ファイル)
  if (exists("b:disable_auto_save_in_buffer") || (&readonly || expand('%:t') ==# 'Result'))
    let g:auto_save = 0 " 自動保存しない

    " 後からw!!で編集権限のないファイルへ書き込みが行われた場合でもバッファが切り替わるまで自動保存をオフにする
    let b:disable_auto_save_in_buffer = 1
  else
    let g:auto_save = 1 " 自動保存
  endif
endfunction

augroup switch_auto_save
  autocmd!
  au BufEnter * call s:auto_save_detect()
augroup END


" augroup switch_list
"   autocmd!
"   autocmd BufEnter * call s:switch_list_mapping()
" augroup end
"
" function! s:switch_list_mapping() abort
"   let wi = getwininfo(win_getid())[0]
"   if wi.loclist
"     echo "Curwin is location list"
"   elseif wi.quickfix
"     echo "Curwin is quickfix"
"   endif
" endfunction

"" 検索結果に移動
" nnoremap <C-c> :cl<CR>
" nnoremap <C-c> :cc<CR>
"
" "" 次の検索結果に移動
" nnoremap <C-n> :cnext<CR>
"
" "" 前の検索結果に移動
" nnoremap <C-p> :cprevious<CR>

"" 検索結果Windowを閉じる
" nnoremap <C-q> <C-w>j<C-w>q
" https://github.com/neomake/neomake/issues/842
nnoremap <C-q> :cclose\|lclose\|TestClose<CR>

" "" 検索結果に移動
" nnoremap <A-c> :ll<CR>
"
" "" 次の検索結果に移動
" nnoremap <A-n> :lnext<CR>
"
" "" 前の検索結果に移動
" nnoremap <A-p> :lprevious<CR>
"
" "" 検索結果Windowを閉じる
" " nnoremap <C-q> <C-w>j<C-w>q
" " https://github.com/neomake/neomake/issues/842
" nnoremap <A-q> :lclose<CR>

" Quickfix
nnoremap <silent> qq :<C-u>call qfutil#toggle()<CR>

nnoremap <silent> <C-n> :<C-u>call qfutil#next(v:count)<CR>
nnoremap <silent> <C-p> :<C-u>call qfutil#previous(v:count)<CR>
nnoremap <silent> g<C-n> :<C-u>call qfutil#last(v:count)<CR>
nnoremap <silent> g<C-p> :<C-u>call qfutil#first(v:count)<CR>

nnoremap <silent> q. :<C-u>call qfutil#toggle_window()<CR>
" nnoremap <silent> qq :<C-u>call qfutil#qq(v:count)<CR>
nnoremap <silent> qn :<C-u>call qfutil#nfile(v:count)<CR>
nnoremap <silent> qp :<C-u>call qfutil#pfile(v:count)<CR>
nnoremap <silent> qa :<C-u>call qfutil#list()<CR>
nnoremap <silent> qo :<C-u>call qfutil#older(v:count)<CR>
nnoremap <silent> qi :<C-u>call qfutil#newer(v:count)<CR>

augroup open_quickfix_window_automatically
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup END

" " 入力キーの辞書
" let s:compl_key_dict = {
"     \ char2nr("\<C-l>"): "\<C-x>\<C-l>",
"     \ char2nr("\<C-n>"): "\<C-x>\<C-n>",
"     \ char2nr("\<C-p>"): "\<C-x>\<C-p>",
"     \ char2nr("\<C-k>"): "\<C-x>\<C-k>",
"     \ char2nr("\<C-t>"): "\<C-x>\<C-t>",
"     \ char2nr("\<C-i>"): "\<C-x>\<C-i>",
"     \ char2nr("\<C-]>"): "\<C-x>\<C-]>",
"     \ char2nr("\<C-f>"): "\<C-x>\<C-f>",
"     \ char2nr("\<C-d>"): "\<C-x>\<C-d>",
"     \ char2nr("\<C-v>"): "\<C-x>\<C-v>",
"     \ char2nr("\<C-u>"): "\<C-x>\<C-u>",
"     \ char2nr("\<C-o>"): "\<C-x>\<C-o>",
"     \ char2nr('s'): "\<C-x>s",
"     \ char2nr("\<C-s>"): "\<C-x>s"
"     \}
" " 表示メッセージ
" let s:hint_i_ctrl_x_msg = join([
"     \ '<C-l>: While lines',
"     \ '<C-n>: keywords in the current file',
"     \ "<C-k>: keywords in 'dictionary'",
"     \ "<C-t>: keywords in 'thesaurus'",
"     \ '<C-i>: keywords in the current and included files',
"     \ '<C-]>: tags',
"     \ '<C-f>: file names',
"     \ '<C-d>: definitions or macros',
"     \ '<C-v>: Vim command-line',
"     \ "<C-u>: User defined completion ('completefunc')",
"     \ "<C-o>: omni completion ('omnifunc')",
"     \ "s: Spelling suggestions ('spell')"
"     \], "\n")
" function! s:hint_i_ctrl_x() abort
"   echo s:hint_i_ctrl_x_msg
"   let c = getchar()
"   return get(s:compl_key_dict, c, nr2char(c))
" endfunction
"
" inoremap <expr> <C-x>  <SID>hint_i_ctrl_x()

let g:brightest#highlight = {
    \   'group' : 'BrightestUnderline'
    \}

" let g:brightest#pattern = '\k\+'
let g:brightest#enable_on_CursorHold = 1

map H <Plug>(operator-quickhl-manual-this-motion)

let g:lsp_signs_enabled = 1        " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_diagnostics_echo_delay = 500
let g:lsp_signs_priority = 10

let g:lsp_textprop_enabled = 1 " エラー部の強調表示。solargraphで複数行削除時にエラーになるため無効化
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_diagnostics_highlights_delay = 2000
" let g:lsp_format_sync_timeout = 1000

let g:lsp_highlight_references_enabled = 1
let g:lsp_diagnostics_virtual_text_enabled=0 " Virtual Text見づらいので無効化
" let g:lsp_diagnostics_virtual_text_wrap = "truncate"
" let g:lsp_diagnostics_virtual_text_align = "after"

highlight LspErrorText cterm=bold ctermbg=none ctermfg=red
highlight LspWarningText cterm=bold ctermbg=none ctermfg=yellow
highlight LspInformationText cterm=bold ctermbg=none ctermfg=blue
highlight LspHintText cterm=bold ctermbg=none ctermfg=green
" highlight LspErrorHighlight cterm=bold ctermbg=none ctermfg=122
" highlight LspWarningHighlight cterm=bold ctermbg=none ctermfg=123
" highlight LspInformationHighlight cterm=bold ctermbg=none ctermfg=124
" highlight LspHintHighlight cterm=bold ctermbg=none ctermfg=125

let g:asyncomplete_auto_popup = 1
" inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() . "\<CR>" : "\<CR>"

let g:lsp_log_verbose = 1

" sudo(root) ではないときだけ
if system("whoami") != "root\n"
  let g:lsp_log_file          = expand('/tmp/vim-lsp.log')
  let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')
endif

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/snippets'

setlocal signcolumn=yes

nnoremap <leader>s :<C-u>call LspRestart(1)<CR>

function! s:on_lsp_buffer_enabled() abort
  let b:lsp_restart_available = 1
  setlocal omnifunc=lsp#complete
  " nnoremap <buffer> <C-n> :<C-u>LspNextDiagnostic<CR>
  " nnoremap <buffer> <C-p> :<C-u>LspPreviousDiagnostic<CR>
  nnoremap <leader>w :<C-u>LspDocumentDiagnostics<cr>
  nmap <C-j> :<C-u>LspDefinition<cr>
  nmap <C-k> :<C-u>LspReferences<cr>
  nmap <C-k>i :<C-u>LspImplementation<cr>
  nnoremap K :<C-u>LspHover<cr>
  nnoremap <C-s> :<C-u>LspRename<CR>
  nnoremap <leader>f :<C-u>LspDocumentFormat<CR>
  vnoremap <leader>f :<C-u>LspDocumentRangeFormat<CR>
  nnoremap <leader>c :<C-u>LspCodeAction<CR>
  nnoremap <leader>s :<C-u>call LspRestart(0)<CR>
endfunction

augroup lsp_enabled
    autocmd!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" lsp restart
function! LspRestart(force) abort
  if !a:force && !exists('b:lsp_restart_available')
    echomsg 'lsp is not available'
    let b:lsp_restart_available = 0
    return
  endif
  if !a:force && b:lsp_restart_available == -1
    return
  endif

  let s:timer = timer_start(100, {t ->
        \ [
        \ execute('DirenvExport', ''),
        \ execute('LspStopServer', ''),
        \]
        \})
  let s:timer2 = timer_start(1000, {t ->
        \ [
        \ execute('let b:lsp_restart_available = -1', ''),
        \ execute(':e!', ''),
        \ execute('echomsg "lsp restarted"', ''),
        \ execute('let b:lsp_restart_available = 1', ''),
        \]
        \})
endfunction


" augroup OnRooterChdir
"   autocmd!
"   autocmd User RooterChDir execute 'DirenvExport' | call LspRestart()
" augroup END

let g:rooter_patterns = ['Gemfile', 'go.mod', '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json']

" Enable efm-langserver for custom linter and formatter
let g:lsp_settings = {
 \  'efm-langserver': {
 \    'disabled': 0,
 \    'allowlist': ['markdown'],
 \  }
 \ }

" Configure efm-langserver in ~/.config/efm-langserver/config.yaml
let g:lsp_settings_filetype_ruby = ['solargraph']
" let g:lsp_settings_filetype_ruby = ['ruby-lsp']

let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server', 'deno']
let g:lsp_settings_filetype_javascript = ['typescript-language-server']

" let g:lsp_settings_filetype_go = ['gopls']
let g:lsp_settings_filetype_go = ['gopls', 'golangci-lint-langserver']

" augroup vim_lsp_golangci_lint_langserver
"   au!
"   autocmd User lsp_setup call lsp#register_server({
"      \ 'name': 'golangci-lint-langserver',
"      \ 'cmd': {server_info->['golangci-lint-langserver']},
"      \ 'initialization_options': {'command': ['golangci-lint', 'run', '--out-format', 'json']},
"      \ 'whitelist': ['go'],
"      \ })
" augroup END


"vim-grammarous
let g:grammarous#default_comments_only_filetypes = {
           \ '*' : 1, 'help' : 0, 'markdown' : 0,
           \ }

" rhysd/vim-operator-surround
" 括弧を追加する
map <silent> sa <Plug>(operator-surround-append)
" 括弧を削除する
map <silent> sd <Plug>(operator-surround-delete)
" 括弧を入れ替える
map <silent> sr <Plug>(operator-surround-replace)

" カーソル位置から一番近い括弧を削除する
nmap <silent> sdd <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)

" カーソル位置から一番近い括弧を変更する
nmap <silent> srr <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)

" キャメルケースとスネークケースの切り替え
map <leader>c <plug>(operator-camelize-toggle)

" text objectの拡張
omap ab <Plug>(textobj-anyblock-a)
omap ib <Plug>(textobj-anyblock-i)
vmap ab <Plug>(textobj-anyblock-a)
vmap ib <Plug>(textobj-anyblock-i)
omap al <Plug>(textobj-line-a)
omap il <Plug>(textobj-line-i)
vmap al <Plug>(textobj-line-a)
vmap il <Plug>(textobj-line-i)

augroup asyncomplete_register_source
  autocmd!
  au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
        \ 'name': 'neosnippet',
        \ 'allowlist': ['*'],
        \ 'priority': 100,
        \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
        \ }))

  au User asyncomplete_setup call asyncomplete#register_source({
       \ 'name': 'look',
       \ 'allowlist': ['*'],
       \ 'priority': 1000,
       \ 'completor': function('asyncomplete#sources#look#completor'),
       \ 'config': {
       \   'line_limit': 1000,
       \   'max_num_result': 20,
       \  },
       \ })

"   au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tabnine#get_source_options({
"      \ 'name': 'tabnine',
"      \ 'allowlist': ['*'],
"      \ 'priority': 1000,
"      \ 'completor': function('asyncomplete#sources#tabnine#completor'),
"      \ 'config': {
"      \   'line_limit': 1000,
"      \   'max_num_result': 20,
"      \  },
"      \ }))
" augroup END
"
" " Delete with backspace to open configuration TabNine
" " TabNine::config.

let g:copilot_filetypes = {
    \ 'gitcommit': v:true,
    \ 'markdown': v:true,
    \ 'yaml': v:true
    \ }
" let g:copilot_no_tab_map = v:true
" imap <silent><script><expr> <C-j> copilot#Accept("\<CR>")

inoremap <expr> <C-n>   pumvisible() ? "\<C-n>" : "\<Plug>(copilot-next)"
inoremap <expr> <C-p>   pumvisible() ? "\<C-p>" : "\<Plug>(copilot-previous)"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

let g:rooter_cd_cmd = 'lcd'
let g:rooter_resolve_links = 1

" disable auto format. but :GoImportRun will work.
" let g:goimports = 0

nnoremap ff :<C-u>FuzzyMotion<CR>
" let g:go_fmt_command = "goimports"

"" incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" 自動でハイライトを消す
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" call ChatGPT with https://github.com/kojix2/chatgpt-cli
command! -range=% ChatGPT call ChatGPTSendSelectedRange(<line1>, <line2>)

" Configuration Parameters
let g:chatgpt_model = 'gpt-4o-2024-05-13'

let g:system_marker = '-----🤖-----'
let g:marker = '-----👇-----'
function! ChatGPTSendSelectedRange(startline, endline) abort
  let l:command = 'chatgpt -M ' . g:chatgpt_model
  let l:startline = a:startline

  let l:resume_file = expand('%:p') . '.post_data.json'

  if filereadable(l:resume_file)
    let l:command = l:command . ' -l ' . l:resume_file

    let l:save_pos = getpos('.')
    call cursor(1, 1)
    let l:markerline = search('^' . g:marker . '$', 'bnw')
    let l:system_markerline = search('^' . g:system_marker . '$', 'bnw')
    call setpos('.', l:save_pos)

    if l:markerline == a:endline
      echomsg 'ChatGPT canceled: Write something to send after ' . g:marker
      return
    endif
    let l:startline = l:markerline + 1
  else
    try
      cnoremap <buffer> <silent> <Esc> __CANCELED__<CR>
      let l:input = input('System Message: ', '', 'customlist,ConfirmCompletion')
      let l:input = l:input =~# '__CANCELED__$' ? 0 : l:input
    catch /^Vim:Interrupt$/
      let l:input = -1
    finally
      silent! cnoremap <buffer> <Esc>

      if l:input ==# '0' || l:input ==# '-1'
        echomsg 'ChatGPT canceled'
        return
      endif
    endtry

    let l:system_message = shellescape(l:input, 1)
    if l:system_message != ''
      let l:command = l:command . ' -s ' . l:system_message
    endif
  endif

  " ファイル名が /tmp/.*/.*\.response\.md の場合はそのファイルを編集
  if expand('%') =~# '/tmp/.*/.*\.response\.md$'
    exec 'edit ' . expand('%')
    let l:outputfile = expand('%')
    " 末尾にマーカーを追加
    call append(line('$'), [g:system_marker])
  else " それ以外の場合は新規バッファを開く
    let l:outputfile = tempname() . '.response.md'
    exec 'vsplit ' . l:outputfile
    " system message
    call setline(1, [l:system_message, g:system_marker])
    exec 'wincmd p'
  endif

  call job_start(l:command, {
        \ 'in_io': 'buffer',
        \ 'in_buf': bufnr('%'),
        \ 'in_top': l:startline,
        \ 'in_bot': a:endline,
        \ 'out_io': 'buffer',
        \ 'out_buf': bufnr(l:outputfile),
        \ 'exit_cb': function('ChatGPTJobCallback', [l:outputfile]),
        \ })
endfunction

function! ChatGPTJobCallback(outputfile, job, status) abort
  if a:status != 0
    call setbufline(bufnr(a:outputfile), 1, 'Error: ChatGPT request failed with status ' . a:status)

    return
  endif

  " 末尾にここからマーカーを追加
  call appendbufline(bufnr(a:outputfile), '$', [g:marker])

  " Restore cursor to system marker line
  call cursor(1, 1)
  let l:system_markerline = search('^' . g:system_marker . '$', 'bnw')
  if l:system_markerline > 0
    call cursor(l:system_markerline, 1)
  endif

  " ~/.config/chatgpt-cli/post_data.json を a:outputfile.json にコピー
  let l:post_data = expand('~/.config/chatgpt-cli/post_data.json')
  let l:post_data_json = a:outputfile . '.post_data.json'
  call system('cp ' . l:post_data . ' ' . l:post_data_json)

  echomsg 'Chat GPT response received'
endfunction

" vnoremap [explorer]a :ChatGPT<CR>
vnoremap [explorer]a :ChatGPT<CR>
noremap [explorer]a :ChatGPT<CR>
