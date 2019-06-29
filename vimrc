" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=9 foldmethod=marker spell nowrap:
"
" Cleaned environment
"
" OS_Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }
" }
"

" Leader definition {
    let mapleader = ','
"

" My sane defaults {

    " Miscellaneous {
        filetype plugin indent on   " Automatically detect file types.
        syntax on                   " Syntax highlighting
        set mouse=a                 " Automatically enable mouse usage
        set mousehide               " Hide the mouse cursor while typing
        scriptencoding utf-8

        if has('clipboard')
            if has('unnamedplus')  " When possible use + register for copy-paste
                set clipboard=unnamed,unnamedplus
            else         " On mac and Windows, use * register for copy-paste
                set clipboard=unnamed
            endif
        endif

        set virtualedit=onemore,block       " Allow for cursor beyond last character
        set history=1000                    " Store a ton of history (default is 20)
        set nospell                         " Spell checking off
        set hidden                          " Allow buffer switching without saving
        set number

        set iskeyword-=.                    " '.' is an end of word designator
        set iskeyword-=#                    " '#' is an end of word designator
        set iskeyword-=-                    " '-' is an end of word designator

        set backspace=indent,eol,start  " Backspace for dummies
        set linespace=0                 " No extra spaces between rows
        set backspace=indent,eol,start  " Backspace for dummies
        set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
        set belloff=all                 " Completely disable the bell for errors and pressing "ESC" on normal mode 

        set nowrap                      " Do not wrap long lines
        set autoindent                  " Indent at the same level of the previous line
        set shiftwidth=4                " Use indents of 4 spaces
        set expandtab                   " Tabs are spaces, not tabs
        set tabstop=4                   " An indentation every four columns
        set softtabstop=4               " Let backspace delete indent
        set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)

        set autowrite

    " }

    " Search {

        set showmatch                   " Show matching brackets/parenthesis
        set incsearch                   " Find as you type search
        set hlsearch                    " Highlight search terms
        set winminheight=0              " Windows can be 0 line high
        set ignorecase                  " Case insensitive search
        set smartcase                   " Case sensitive when uc present
        set nowrapscan

    " }

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

    " Vim UI {
        set cursorline                  " Highlight current line

        highlight clear SignColumn      " SignColumn should match background
        highlight clear LineNr          " Current line number row will have same background color in relative mode
        set tabpagemax=15               " Only show 15 tabs
        set linespace=0                 " No extra spaces between rows
        if OSX()
            set guifont=Menlo:h16
        endif

    " }

    " Status line {
    "   TBD

        set ruler                   " Show the ruler
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
        set showmode                " Display the current mode
        set laststatus=2
        set wildmenu                    " Show list instead of just completing
        set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    " }

    " Useful shortcuts {
        " Code folding options
        nmap <leader>f0 :set foldlevel=0<CR>
        nmap <leader>f1 :set foldlevel=1<CR>
        nmap <leader>f2 :set foldlevel=2<CR>
        nmap <leader>f3 :set foldlevel=3<CR>
        nmap <leader>f4 :set foldlevel=4<CR>
        nmap <leader>f5 :set foldlevel=5<CR>
        nmap <leader>f6 :set foldlevel=6<CR>
        nmap <leader>f7 :set foldlevel=7<CR>
        nmap <leader>f8 :set foldlevel=8<CR>
        nmap <leader>f9 :set foldlevel=9<CR>
    " }
" }


" Plugins support {
	" Use ~/.virc_bundels to load plugins
	" Use bundles config {
	if filereadable(expand("~/.vimrc_bundles"))
		source ~/.vimrc_bundles
	endif
" }

