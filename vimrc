" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={,} foldlevel=9 foldmethod=marker nowrap:
" Python venvs ------------------------------------------------------------{{{

let g:plugins_dir = expand('$HOME/.vim/plugged')
let g:python3_host_prog = expand('$HOME/.vim/.venv/bin/python')
"}}}
"
" Leader definition {
    let mapleader = ','
"}

set nocompatible
set belloff=all
" Use systems clipboard
set clipboard=unnamedplus

  " allow plugins by file type (required for plugins!)
filetype plugin on
filetype indent on

" always show status bar
set ls=2

" incremental search
set incsearch
" highlighted search results
set hlsearch

" syntax highlight on
syntax on


" tabs and spaces handling
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" show line numbers
set nu

  " Easy changing between buffers
    map <c-j> :bnext<cr>
    map <c-k> :bprevious<cr>

  " Easy change between Windows
    noremap <c-l> <c-w>l
    noremap <c-h> <c-w>h
    map <c-up> <c-w>k
    map <c-down> <c-w>j
    map <c-right> <c-w>l
    map <c-left> <c-w>h

      " Use alt keys
    map <A-l> <C-W>l
    map <A-h> <C-W>h
    map <A-j> <C-W>j
    map <A-k> <C-W>k

" Active plugins
" You can disable or add new ones here:

" this needs to be here, so vim-plug knows we are declaring the plugins we
" want to use

call plug#begin(g:plugins_dir)

  " Override configs by directory
  " 
  Plug 'arielrossanigo/dir-configs-override.vim'

  " buffer management
  Plug 'moll/vim-bbye'

  " Better file browser
  Plug 'scrooloose/nerdtree'

  " Search results counter
  Plug 'vim-scripts/IndexedSearch'

  Plug 'natanbro/vim-monokai-tasty'
  " Plug 'patstockwell/vim-monokai-tasty'
  " Airline
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
    " Consoles as buffers (neovim has its own consoles as buffers)
    Plug 'rosenfeld/conque-term'

" Yank history navigation
Plug 'vim-scripts/YankRing.vim'

" Ack code search (requires ack installed in the system)
Plug 'mileszs/ack.vim'
" Paint css colors with the real color
Plug 'lilydjwg/colorizer'
" Window chooser
Plug 't9md/vim-choosewin'


  Plug 'tpope/vim-repeat'
  "mappings for working with JSON in Vim:
  Plug 'https://github.com/tpope/vim-jdaddy'

    " Markdown
  Plug 'https://github.com/plasticboy/vim-markdown/'
  Plug 'https://github.com/previm/previm/'
  Plug 'https://github.com/tyru/open-browser.vim'
  Plug 'https://github.com/instant-markdown/vim-instant-markdown.git'


" Tell vim-plug we finished declaring plugins, so it can load them
call plug#end()

" ============================================================================
" Install plugins the first time vim runs

" use 256 colors when possible
if has('gui_running') || (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256')
    if !has('gui_running')
        let &t_Co = 256
    endif
    if isdirectory('vim/plugged/vim-monokai-tasty/')
      colorscheme vim-monokai-tasty
    endif
else
    colorscheme delek
endif

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" fix problems with uncommon shells (fish, xonsh) and plugins running commands
" (neomake, ...)
set shell=/bin/bash 

" nicer colors
highlight DiffAdd           cterm=bold ctermbg=none ctermfg=119
highlight DiffDelete        cterm=bold ctermbg=none ctermfg=167
highlight DiffChange        cterm=bold ctermbg=none ctermfg=227
highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227

