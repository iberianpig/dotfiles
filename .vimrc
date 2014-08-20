"http://vimblog.hatenablog.com/entry/vimrc_introduction
set number         " 行番号を表示する
" set cursorline     " カーソル行の背景色を変える
" set cursorcolumn   " カーソル位置のカラムの背景色を変える
au WinEnter * set cursorline cursorcolumn
au WinLeave * set nocursorline nocursorcolumn
autocmd InsertEnter,InsertLeave * set cursorline!
autocmd InsertEnter,InsertLeave * set cursorcolumn!

set laststatus=2   " ステータス行を常に表示
set cmdheight=1    " メッセージ表示欄を2行確保
set showmatch      " 対応する括弧を強調表示
set helpheight=998 " ヘルプを画面いっぱいに開く
set list           " 不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮ " 不可視文字の表示記号指定
set t_Co=256 "ターミナルで256色利用

nnoremap sr :<C-u>setlocal relativenumber!<CR>  "相対行番号表示

" Charset, Line ending -----------------
" scriptencoding utf-8
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set ffs=unix,dos,mac  " LF, CRLF, CR
if exists('&ambiwidth')
  set ambiwidth=double  " UTF-8の□や○でカーソル位置がずれないようにする
endif

"カーソル移動系
set backspace=indent,eol,start "Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,] "行頭行末の左右移動で行をまたぐ
set scrolloff=8                "上下8行の視界を確保
set sidescrolloff=16           " 左右スクロール時の視界を確保
set sidescroll=1               " 左右スクロールは一文字づつ行う
set lazyredraw                 "描画を遅延させる"
" set nolazyredraw                 "描画を遅延させない"
set redrawtime=100             "再描画までの時間(デフォルトは2000)"
set ttyfast                    " カーソル移動高速化

"File処理関連
set confirm "保存されていないファイルがあるときは終了前に保存確認
set hidden "保存されていないファイルがあるときでも別のファイルを開くことが出来る
set autoread "外部でファイルに変更がされた場合は読みなおす
set nobackup "ファイル保存時にバックアップファイルを作らない
set noswapfile "ファイル編集中にスワップファイルを作らない

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
inoremap <C-e> <C-o>$<Right>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-k> <C-o>D<Right>
inoremap <C-u> <C-o>d^
inoremap <C-w> <C-o>db

" " j, k による移動を折り返されたテキストでも自然に振る舞うように変更
" nnoremap j gj
" nnoremap k gk
nnoremap <Up> gk
nnoremap <Down> gj

" vを二回で行末まで選択
vnoremap v $h

" TABにて対応ペアにジャンプ
nnoremap &lt;Tab&gt; %
vnoremap &lt;Tab&gt; %

"ビープの設定
"ビープ音すべてを無効にする
set visualbell t_vb=
set noerrorbells "エラーメッセージの表示時にビープを鳴らさない

"コマンドライン設定
" コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full
" コマンドラインの履歴を1000件保存する
set history=1000

" 動作環境との統合
" OSのクリップボードをレジスタ指定無しで Yank, Put 出来るようにする
set clipboard=unnamed,unnamedplus
"screen利用時設定
 set ttymouse=xterm2
"set ttymouse=xterm

" マウスの入力を受け付ける
set mouse=a
" インサートモードから抜けると自動的にIMEをオフにする
" set iminsert=2
" ESCでIMEを確実にOFF
" inoremap <ESC> <ESC>:set iminsert=0<CR>
" inoremap <ESC> <ESC>:set iminsert=0<CR>:redraw!<CR>:redraws!<CR>
""Ctrl-Cでインサートモードを抜ける
inoremap <C-c> <ESC>
"map <ESC> <C-[>

if has('unix') && !has('gui_running')
  " ESC後にすぐ反映されない対策
  " inoremap <silent> <ESC> <ESC>
  " inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>:redraw!<CR>:redraws!<CR>
  map <silent> <ESC> <ESC>:set iminsert=0<CR>:redraw!<CR>:redraws!<CR>
endif

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

" 入力モード中に素早くJJと入力した場合はESCとみなす
inoremap jj <Esc>

" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>:redraw!<CR>:redraws!<CR>


"tab/indentの設定
set shellslash
set expandtab "タブ入力を複数の空白入力に置き換える
set tabstop=2 "画面上でタブ文字が占める幅
set shiftwidth=2 "自動インデントでずれる幅
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent "改行時に前の行のインデントを継続する
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減する

" 日本語ヘルプを利用する
set helplang=ja,en

".vimrcの編集用
nnoremap <Space>. :<C-u>tabedit $MYVIMRC<CR>

"タブの設定
" The prefix key.
nnoremap    [Tag]   <Nop>
nmap  t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" tn 新しいタブを一番右に作る
map <silent> [Tag]n :tablast <bar> tabnew<CR>
" " tx タブを閉じる
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]c :tabclose<CR>
map <silent> [Tag]h :tabprevious<CR>
map <silent> [Tag]l :tabnext<CR>


" NeoBundle がインストールされていない時、
" もしくは、プラグインの初期化に失敗した時の処理
function! s:WithoutBundles()
  colorscheme desert
  " その他の処理
endfunction

" NeoBundle よるプラグインのロードと各プラグインの初期化
function! s:LoadBundles()

  NeoBundleCheck
  " 読み込むプラグインの指定
  NeoBundle 'Shougo/neobundle.vim'
  NeoBundle 'Shougo/neocomplcache.vim'
  NeoBundle 'Shougo/neosnippet.vim'
  NeoBundle 'Shougo/neosnippet-snippets'
  NeoBundle 'Shougo/neomru.vim'
  NeoBundle 'Shougo/vimshell.git'
  " vimprocのインストールとbuild
  " " 自動でインストールしてビルド(make)してくれる
  NeoBundle 'Shougo/vimproc', {
        \ 'build' : {
        \ 'windows' : 'make -f make_mingw32.mak',
        \ 'cygwin' : 'make -f make_cygwin.mak',
        \ 'mac' : 'make -f make_mac.mak',
        \ 'unix' : 'make -f make_unix.mak',
        \ },
        \ }
  NeoBundle 'honza/vim-snippets'
  NeoBundle 'tpope/vim-surround'
  NeoBundle 'tpope/vim-rails'
  NeoBundle 'tpope/vim-fugitive'
  NeoBundle 'Shougo/unite.vim'
  NeoBundle 'ujihisa/unite-colorscheme'
  NeoBundle 'sgur/unite-qf'
  NeoBundle 'thinca/vim-quickrun'
  NeoBundle 'rcmdnk/vim-markdown'
  " NeoBundle 'superbrothers/vim-quickrun-markdown-gfm'
  NeoBundle 'tyru/open-browser.vim'
  NeoBundle 'Shougo/vimfiler'
  NeoBundle 'thinca/vim-guicolorscheme'
  NeoBundle 'itchyny/lightline.vim'
  NeoBundle 'junegunn/vim-easy-align'
  NeoBundle 'terryma/vim-multiple-cursors'
  NeoBundle 'AndrewRadev/switch.vim'
  NeoBundle 'kana/vim-submode'
  NeoBundle 'tomtom/tcomment_vim'
  NeoBundle 'mattn/emmet-vim'
  NeoBundle 'osyo-manga/vim-over'
  NeoBundle 'glidenote/octoeditor.vim'
  " NeoBundle 'tpope/vim-liquid' 
  " NeoBundle 'mattn/gist-vim'
  NeoBundle 'mattn/webapi-vim'
  NeoBundle 'vim-scripts/vim-auto-save'
  NeoBundle 'syui/cscroll.vim'
  " NeoBundle 'xolox/vim-session', { 'depends' : 'xolox/vim-misc',}
  NeoBundle 'Shougo/unite-outline'
  NeoBundle 'ujihisa/unite-locate'
  NeoBundle 'sgur/unite-git_grep'
  NeoBundle 'ujihisa/quicklearn'
  NeoBundle 'thinca/vim-ref'
  NeoBundle 'mfumi/ref-dicts-en'
  NeoBundle 'tyru/vim-altercmd'
  NeoBundle 'ujihisa/neco-look'
  NeoBundle 'scrooloose/syntastic'
  NeoBundle 'alpaca-tc/alpaca_tags'
  NeoBundle 'vim-ruby/vim-ruby'
  NeoBundle 'Townk/vim-autoclose' 
  NeoBundle 'ujihisa/unite-font' 
  NeoBundle 'airblade/vim-gitgutter'
  NeoBundle 'rhysd/migemo-search.vim'
  " NeoBundle 'haya14busa/vim-migemo'
  NeoBundle 'kien/ctrlp.vim'
  NeoBundle 'vim-scripts/fcitx.vim'
  NeoBundle 'Lokaltog/vim-easymotion'
  " NeoBundle 'joker1007/vim-markdown-quote-syntax'
  NeoBundle 'kannokanno/previm'
  NeoBundle 'lambdalisue/vim-gista' 
  NeoBundle 'alpaca-tc/vim-endwise.git'
  NeoBundle 'edsono/vim-matchit'
  NeoBundle 'basyura/unite-rails'
  NeoBundle 'alpaca-tc/neorspec.vim'
  NeoBundle 'tpope/vim-dispatch'
  NeoBundle 'aurigadl/vim-angularjs'


  "colorscheme
  NeoBundle 'altercation/vim-colors-solarized'
  NeoBundle 'croaker/mustang-vim'
  NeoBundle 'jeffreyiacono/vim-colors-wombat'
  NeoBundle 'nanotech/jellybeans.vim'
  NeoBundle 'vim-scripts/Lucius'
  NeoBundle 'vim-scripts/Zenburn'
  NeoBundle 'mrkn/mrkn256.vim'
  NeoBundle 'jpo/vim-railscasts-theme'
  NeoBundle 'therubymug/vim-pyte'
  NeoBundle 'w0ng/vim-hybrid'
  " ...
  " 読み込んだプラグインの設定
  " ...
  
  set background=light "明るめの背景
  " set background=dark "暗めの背景
  colorscheme hybrid "set colorscheme
  let g:lightline = {
        \ 'colorscheme': 'Tomorrow_Night',
        \ 'active': {
        \   'right': [ [ 'syntastic', 'lineinfo' ],
        \              [ 'percent' ],
        \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ 'component_expand': {
        \   'syntastic': 'SyntasticStatuslineFlag',
        \ },
        \ 'component_type': {
        \   'syntastic': 'error',
        \ }
        \ }


  let g:syntastic_mode_map = { 'mode': 'passive' }
  augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp call s:syntastic()
  augroup END
  function! s:syntastic()
    SyntasticCheck
    call lightline#update()
  endfunction

  "" vimfiler
  let g:vimfiler_as_default_explorer=1
  " let g:vimfiler_edit_action = 'tabopen'
  let g:vimfiler_ignore_pattern='\(^\.\|\~$\|\.pyc$\|\.[oad]$\)'
  "autocmd VimEnter * VimFiler -buffer-name=explorer -split -simple -winwidth=30 -toggle -no-quit
  nnoremap <C-k><C-f> :VimFiler -project<CR>
  inoremap <C-k><C-f> <ESC>:VimFiler -project<CR>
  nnoremap <C-k><C-k> :VimFiler -buffer-name=explorer -split -simple -project -winwidth=29 -toggle -no-quit<CR>
  nnoremap <C-k><C-b> :VimFilerBufferDir -buffer-name=explorer -split -simple -winwidth=29 -toggle -no-quit<CR>
  autocmd FileType vimfiler 
        \ nnoremap <buffer><silent>/ 
        \ :<C-u>UniteWithBufferDir file<CR>
  "" neocomplcache
  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1
  " Use smartcase.
  let g:neocomplcache_enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplcache_min_syntax_length = 3
  " Define dictionary.
  let g:neocomplcache_dictionary_filetype_lists = {
        \ 'default' : ''
        \ }
  let g:neocomplcache_force_overwrite_completefunc=1
  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplcache#undo_completion()
  inoremap <expr><C-l>     neocomplcache#complete_common_string()
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplcache#close_popup()
  inoremap <expr><C-e>  neocomplcache#cancel_popup()

  " "NeoSnippet.vim
  let g:neosnippet#enable_snipmate_compatibility = 1
  " Tell Neosnippet about the other snippets
  let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets, ~/.vim/snippets'
  " Plugin key-mappings.
  imap <Nul> <C-Space>
  imap <C-Space>     <Plug>(neosnippet_expand_or_jump)
  smap <C-Space>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-Space>     <Plug>(neosnippet_expand_target)
  " 補完候補が表示されている場合は確定。そうでない場合は改行
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    if(pumvisible())
      return neocomplcache#close_popup()
    endif
    return "\<CR>"
  endfunction

  " For snippet_complete marker.
  if has('conceal')
    set conceallevel=2 concealcursor=i
  endif

  " " neosnippet.vim公式指定をちょっといじる
  imap <expr><TAB> neosnippet#jumpable() ?
         \ "\<Plug>(neosnippet_expand_or_jump)"
         \: pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neosnippet#jumpable() ?
         \ "\<Plug>(neosnippet_expand_or_jump)"
         \: "\<TAB>"

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
  " nnoremap <A-S-Left>  <C-w><<CR>
  " nnoremap <A-S-Right> <C-w>><CR>
  " nnoremap <A-S-Up>    <C-w>-<CR>
  " nnoremap <A-S-Down>  <C-w>+<CR>

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
  let g:unite_source_file_mru_limit = 200
  " file_recのキャッシュ
  " let g:unite_source_rec_max_cache_files = 50000
  " let g:unite_source_rec_min_cache_files = 100
  
  
  "Like ctrlp.vim settings.
  call unite#custom#profile('default', 'context', {
  \   'start_insert': 1,
  \   'direction': 'botright',
  \ })

  call unite#filters#sorter_default#use(['sorter_ftime*'])
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
  " 画像はキャッシュしない
  call unite#custom#source('file_rec/async', 'ignore_pattern', '\(png\|gif\|jpeg\|jpg\)$')
  " ファイルはタブで開く
  call unite#custom_default_action('file', 'tabopen')

  "prefix keyの設定
  nmap <Space> [unite]
  ""スペースキーとaキーでカレントディレクトリを表示
  nnoremap <silent> [unite]a :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
  "スペースキーとfキーでバッファと最近開いたファイル一覧を表示
  nnoremap <silent> [unite]f :<C-u>Unite<Space> buffer file_mru<CR>
  "スペースキーとdキーで最近開いたディレクトリを表示
  nnoremap <silent> [unite]d :<C-u>Unite<Space> directory_mru<CR>
  "スペースキーとbキーでバッファを表示
  "nnoremap <silent> [unite]b :<C-u>Unite<Space>buffer<CR>
  ""スペースキーとrキーでレジストリを表示
  " nnoremap <silent> [unite]r :<C-u>Unite<Space> register<CR>
  "スペースキーとtキーでタブを表示
  nnoremap <silent> [unite]t :<C-u>Unite<Space>  tab<CR>
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
  " grep検索結果の再呼出
  nnoremap <silent> [unite]r  :<C-u>UniteResume search-buffer <CR>
  " git-grep
  nnoremap <silent> [unite]gg  :<C-u>:Unite vcs_grep/git <CR>
  " bookmark
  nnoremap <silent> [unite]b :<C-u>Unite bookmark <CR>
  " add to  bookmark
  nnoremap <silent> [unite]ba :<C-u>UniteBookmarkAdd <CR>

  ""スペースキーとENTERキーでfile_rec:!
  " 速度に難ありのため除外中
  " nnoremap [unite]<CR> :<C-u>execute
  "       \ 'Unite'
  "       \ 'buffer'
  "       \ 'file_rec/async:!:'.fnameescape(expand('%:p:h'))
  "       \ '-default-action=tabopen'<CR>

  "unite.vimを開いている間のキーマッピング
  autocmd FileType unite call s:unite_my_settings()
  function! s:unite_my_settings()
    " ESCでuniteを終了
    " nnoremap <silent><ESC> <Plug>(unite_all_exit)
    " rerwite chache
    nnoremap <C-c> <Plug>(unite_redraw)
    "ESCでuniteを終了
    nmap <buffer> <ESC> <Plug>(unite_exit)
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
  let g:ctrlp_use_migemo = 1
  let g:ctrlp_clear_cache_on_exit = 0   " 終了時キャッシュをクリアしない
  let g:ctrlp_mruf_max            = 500 " MRUの最大記録数
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
        \ 'PrtClearCache()':      ['<F5>'],
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
  let g:octopress_unite = 1
  " let g:octopress_auto_open_results = 1
  " use unite (default 0)
  let g:octopress_unite = 1
  " use arbitrary unite option (default is empty)
  let g:octopress_unite_option = "-no-split -start-insert -auto-preview"
  " use arbitrary unite source (default is 'file')
  " let g:octopress_unite_source = "file_rec/async"
  " let g:octopress_qfixgrep = 0
  map [unite]on  :OctopressNew<CR>
  map [unite]ol  :OctopressList<CR>
  map [unite]og  :OctopressGrep<CR>
  map [unite]oG   :OctopressGenerate<CR>
  map [unite]oD  :OctopressDeploy<CR>

  " "gist-vim
  " let g:gist_detect_filetype = 1
  " let g:github_user  = 'iberianpig'
  " " Only :w! updates a gist.
  " let g:gist_update_on_write = 2

  " [,]+j+j+j...で下にスクロール、[,]+k+k+k...で上にスクロール
  nnoremap <A-j> :ChromeScrollDown<CR>
  nnoremap <A-k> :ChromeScrollUp<CR>
  call submode#enter_with('cscroll', 'n', '', '<Leader>j', ':ChromeScrollDown<CR>')
  call submode#enter_with('cscroll', 'n', '', '<Leader>k', ':ChromeScrollUp<CR>')
  call submode#leave_with('cscroll', 'n', '', 'n')
  call submode#map('cscroll', 'n', '', 'j', ':ChromeScrollDown<CR>')
  call submode#map('cscroll', 'n', '', 'k', ':ChromeScrollUp<CR>')

  " 現在のタブを閉じる
  nnoremap <silent> <Leader>q :ChromeTabClose<CR>
  " [,]+f+{char}でキーを Google Chrome に送る
  " nnoremap <buffer> <Leader>f :ChromeKey<Space>

    "quickrun
  set spelllang+=cjk
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  let g:quickrun_config = {}
  " let g:quickrun_config['markdown'] = {
  "       \   'command': 'PrevimOpen'
  "       \ }
  "       " \   'outputter': 'browser'
  " let g:quickrun_config['mkd'] = {
  "       \   'command': 'PrevimOpen'
  "       \ }
  " let g:quickrun_config['md'] = {
  "       \   'command': 'PrevimOpen'
  "       \ }
  au FileType markdown nmap <Leader>r :PrevimOpen<CR>

  nnoremap <space>R :<C-u>Unite quicklearn -immediately<Cr>

  " " vim-session
  " " 現在のディレクトリ直下の .vimsessions/ を取得 
  " let s:local_session_directory = xolox#misc#path#merge(getcwd(), '.vimsessions')
  " " 存在すれば
  " if isdirectory(s:local_session_directory)
  "   " session保存ディレクトリをそのディレクトリの設定
  "   let g:session_directory = s:local_session_directory
  "   " vimを辞める時に自動保存
  "   let g:session_autosave = 'yes'
  "   " 引数なしでvimを起動した時にsession保存ディレクトリのdefault.vimを開く
  "   let g:session_autoload = 'yes'
  "   " 1分間に1回自動保存
  "   let g:session_autosave_periodic = 1
  " else
  "   let g:session_autosave = 'no'
  "   let g:session_autoload = 'no'
  " endif


  " vim-ref のバッファを q で閉じられるようにする
  autocmd FileType ref-* nnoremap <buffer> <silent> q :<C-u>close<CR>

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
    return join(split(a:output, "\n")[15 :], "\n")
  endfunction

  function! g:ref_source_webdict_sites.ej.filter(output)
    return join(split(a:output, "\n")[15 :], "\n")
  endfunction

  call altercmd#load()
  CAlterCommand ej Ref webdict ej
  CAlterCommand je Ref webdict je

  "syntasitc[rubocop]
  " let g:syntastic_ruby_checkers = ['rubocop']
  " let g:syntastic_enable_signs=1
  " let g:syntastic_auto_loc_list=2
  " let g:syntastic_mode_map = {'mode': 'passive'} 
  " augroup AutoSyntastic
  "   autocmd!
  "   autocmd InsertLeave,TextChanged * call s:syntastic() 
  " augroup END
  " function! s:syntastic()
  "   w
  "   SyntasticCheck
  " endfunction

  " " AlpacaTags
  " augroup AlpacaTags
  "   autocmd!
  "   if exists(':Tags')
  "     autocmd BufWritePost Gemfile TagsBundle
  "     autocmd BufEnter * TagsSet
  "     " 毎回保存と同時更新する場合はコメントを外す
  "     autocmd BufWritePost * TagsUpdate
  "   endif
  " augroup END

  "tcomment_vim 
  " tcommentで使用する形式を追加
  if !exists('g:tcomment_types')
    let g:tcomment_types = {}
  endif
  let g:tcomment_types = {
        \'php_surround' : "<?php %s ?>",
        \'eruby_surround' : "<%% %s %%>",
        \'eruby_surround_minus' : "<%% %s -%%>",
        \'eruby_surround_equality' : "<%%= %s %%>",
        \}

  " マッピングを追加
  function! SetErubyMapping2()
    nmap <buffer> <C-/>c :TCommentAs eruby_surround<CR>
    nmap <buffer> <C-/>- :TCommentAs eruby_surround_minus<CR>
    nmap <buffer> <C-/>= :TCommentAs eruby_surround_equality<CR>

    vmap <buffer> <C-/>c :TCommentAs eruby_surround<CR>
    vmap <buffer> <C-/>- :TCommentAs eruby_surround_minus<CR>
    vmap <buffer> <C-/>= :TCommentAs eruby_surround_equality<CR>
  endfunction

  " erubyのときだけ設定を追加
  au FileType eruby call SetErubyMapping2()
  " phpのときだけ設定を追加
  au FileType php nmap <buffer><C-/>c :TCommentAs php_surround<CR>
  au FileType php vmap <buffer><C-/>c :TCommentAs php_surround<CR>

  "gitgutter
  let g:gitgutter_diff_args = '-w'
  nnoremap <silent> ,gg :<C-u>GitGutterToggle<CR>
  nnoremap <silent> ,gh :<C-u>GitGutterLineHighlightsToggle<CR>

  "migemosearch
  if executable('cmigemo')
    cnoremap <expr><CR> migemosearch#replace_search_word()."\<CR>"
  endif

  "previm
  augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
  augroup END

  "gista
  let g:gista#github_user = 'iberianpig'
  ""unite
  nnoremap <silent> [unite]gs :<C-u>Unite<Space> gista<CR>

  " for open-browser plugin
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

  "読み込んだプラグインの設定ここまで
endfunction

" NeoBundle がインストールされているなら LoadBundles() を呼び出す
" そうでないなら WithoutBundles() を呼び出す
function! s:InitNeoBundle()
  if isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    filetype plugin indent off
    if has('vim_starting')
      set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    try
      call neobundle#rc(expand('~/.vim/bundle/'))
      call s:LoadBundles()
    catch
      call s:WithoutBundles()
    endtry 
  else
    call s:WithoutBundles()
  endif

  filetype indent plugin on
  syntax on
endfunction

call s:InitNeoBundle()


