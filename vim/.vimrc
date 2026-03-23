
set nocompatible
set number relativenumber
set tabstop=4 shiftwidth=4 expandtab
set ignorecase smartcase
set incsearch hlsearch
set mouse=a
set termguicolors
set regexpengine=0
set redrawtime=10000
syntax on
set background=dark

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'tpope/vim-sensible'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

colorscheme catppuccin_mocha
