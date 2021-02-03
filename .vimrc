if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
"set runtimepath+=/home/vagrant/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
"if dein#load_state('/home/vagrant/.cache/dein')
"  call dein#begin('/home/vagrant/.cache/dein')

  " Let dein manage dein
  " Required:
"  call dein#add('/home/vagrant/.cache/dein/repos/github.com/Shougo/dein.vim')

"  call dein#add('Shougo/dein.vim')
"  call dein#add('Shougo/deoplete.nvim')
"  call dein#add('tpope/vim-endwise')


"  call dein#end()
"  call dein#save_state()
"endif

" --------------------------------
" 基本設定
" --------------------------------
" vim内部で使われる文字エンコーディングをutf-8に設定する
set encoding=utf-8

" 想定される改行コードの指定する
set fileformats=unix,dos,mac

" ハイライトを有効化する
syntax enable

" 挿入モードでTABを挿入するとき、代わりに適切な数の空白を使う
set expandtab

" 新しい行を開始したとき、新しい行のインデントを現在行と同じにする
set autoindent

" ファイル形式の検出の有効化する
" ファイル形式別プラグインのロードを有効化する
" ファイル形式別インデントのロードを有効化する
filetype plugin indent on

set backspace=indent,eol,start
set number
set nobackup
set noswapfile
set shiftwidth=2

