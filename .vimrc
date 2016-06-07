" NeoBundle
" NeoBundle がインストールされていない時、
" もしくは、プラグインの初期化に失敗した時の処理
function! s:WithoutBundles()
  colorscheme desert
    " その他の処理
endfunction

" NeoBundle よるプラグインのロードと各プラグインの初期化
function! s:LoadBundles()
  " 読み込むプラグインの指定
  NeoBundle 'Shougo/neobundle.vim'
  NeoBundle 'tpope/vim-surround'

  " ファイルオープンを便利に
  NeoBundle 'Shougo/unite.vim'
  " Unite.vimで最近使ったファイルを表示できるようにする
  NeoBundle 'Shougo/neomru.vim'
  " ファイルをtree表示してくれる
  NeoBundle 'scrooloose/nerdtree'
  " Gitを便利に使う
  NeoBundle 'tpope/vim-fugitive'

  " コメントON/OFFを手軽に実行
  NeoBundle 'tomtom/tcomment_vim'
  " シングルクオートとダブルクオートの入れ替え等
  NeoBundle 'tpope/vim-surround'

  " ログファイルを色づけしてくれる
  NeoBundle 'vim-scripts/AnsiEsc.vim'
  " less用のsyntaxハイライト
  NeoBundle 'KohPoll/vim-less'
  " ちょっとしたコード片を書いて実行して確認
  NeoBundle 'thinca/vim-quickrun'
  " grepを便利にしてくれる
  NeoBundle 'grep.vim'
  " agを使用
  NeoBundle 'rking/ag.vim'


" 余談: neocompleteは合わなかった。ctrl+pで補完するのが便利


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
      call neobundle#begin(expand('~/.vim/bundle/'))
      "call neobundle#rc(expand('~/.vim/bundle/'))
        call s:LoadBundles()
      call neobundle#end()
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

""""""""""""""""""""""""""""""
" 各種オプションの設定
""""""""""""""""""""""""""""""
"バックアップ設定
set nobackup 
" スワップファイルは使わない
set noswapfile
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
" 入力中のコマンドを表示する
set showcmd
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" 検索結果をハイライト表示する
set hlsearch
" 検索ワードの最初の文字を入力した時点で検索を開始する
set incsearch
" 不可視文字を表示する
set list
" タブと行の続きを可視化する
set listchars=tab:>\ ,extends:<,trail:-
" 改行時に前の行のインデントを継続する
set autoindent
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" タブ文字の表示幅
set tabstop=4
" タブ押下時の幅
set softtabstop=4
" Vimが挿入するインデントの幅
set shiftwidth=4
" タブをスペースに展開しない (expandtab:展開する)
set expandtab
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
"colorscheme evening " (Windows用gvim使用時はgvimrcを編集すること)
" 行番号表示
set number
" unファイルをオフ
set noundofile

" 構文毎に文字色を変化させる
syntax on
""""""""""""""""""""""""""""""


" http://blog.remora.cx/2010/12/vim-ref-with-unite.html
""""""""""""""""""""""""""""""
" Unit.vimの設定
""""""""""""""""""""""""""""""
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
" grep検索
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
" grep検索結果の再呼出
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>

" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif
""""""""""""""""""""""""""""""

" http://inari.hatenablog.com/entry/2014/05/05/231307
""""""""""""""""""""""""""""""
" 全角スペースの表示
""""""""""""""""""""""""""""""
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" キーマップ
""""""""""""""""""""""""""""""
" Tree表示
noremap <C-J> :NERDTree<CR>
" ノーマルモード時だけ ; と : を入れ替える
noremap ; :
noremap : ;

""""""""""""""""""""""""""""""

" filetypeの自動検出(最後の方に書いた方がいいらしい)
filetype on

" cocos用辞書追加
autocmd FileType cpp set dictionary=~/.vim/dict/cocos2d-js.dict
autocmd FileType hpp set dictionary=~/.vim/dict/cocos2d-js.dict
autocmd FileType h set dictionary=~/.vim/dict/cocos2d-js.dict