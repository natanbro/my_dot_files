" Modeline and Notes
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
" functions {
"

    function! IsPluginInstalled(name)
        let s:myrtp = split((&rtp), ',')
        if matchstr(s:myrtp, a:name) != ""
            unlet s:myrtp
            return 1
        endif
        unlet s:myrtp
    endfunc
    "
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        let common_dir = parent . '/.' . prefix

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()

" }

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
        set relativenumber

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
        set splitright                  " Puts new vsplit windows to the right of the current
        set splitbelow                  " Puts new split windows to the bottom of the current

        set shortmess+=filmnrxoOtT      " Abbrev. of messages (avoids 'hit enter')

        set autowrite

        set foldenable
        set foldlevel=9
        set listchars=tab:›\ ,trail:•,eol:$,extends:#,nbsp:. " Highlight problematic whitespace
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
    " }

    " Vim UI {
        set cursorline                  " Highlight current line

        highlight clear SignColumn      " SignColumn should match background
        highlight clear LineNr          " Current line number row will have same background color in relative mode
        set tabpagemax=15               " Only show 15 tabs
        set linespace=0                 " No extra spaces between rows
        if has('gui')
            set lines=41                " 40 lines of text instead of 24
            " disable GUI menus
            set guioptions-=m
            set guioptions-=M 

            " disable GUI toolbar
            set guioptions-=T           " Remove the toolbar


            if LINUX() && has("gui")
                 set guifont=Andale\ Mono\ Regular\ 11,Menlo\ Regular\ 11,Consolas\ Regular\ 11,Courier\ New\ Regular\ 11
            elseif OSX() && has("gui")
                set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h14,Consolas\ Regular:h14,Courier\ New\ Regular:h14
            elseif WINDOWS() && has("gui")
                set guifont=Andale_Mono:h12,Menlo:h12,Consolas:h12,Courier_New:h12
            endif
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

" }

" Disable common typos {
    " Disable X mode
    :map Q <Nop>

    :command! WQ wq
    :command! Wq wq
    :command! W w
    :command! Q q

    " Common finger slips in English
    :ab THe The
    :ab THey They
    :ab teh the
    :ab THis This
    :ab THese These
    :ab THere There
" }

" }

" Useful mappings {
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
    "
    " Wrapped lines goes down/up to next row, rather than next line in file.
        noremap j gj
        noremap k gk
    
    " Visual shifting (does not exit Visual mode)
        vnoremap < <gv
        vnoremap > >gv

    " Should have been default
    "
        nnoremap Y y$

    " toggle spelling and search highlight
        nmap <silent> <leader>/ :set invhlsearch<CR>
        nmap <silent><leader>\  :set invspell<CR>

    "Split line at cursor position leaving cursor in place
        nnoremap <c-Enter> i<cr><esc>k$

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
        vnoremap . :normal .<CR>
    "
    "
    " Easy changing between buffers
        map <c-j> :bnext<cr>
        map <c-k> :bprevious<cr>

    " Easy change between Windows
        map <C-L> <C-W>l
        map <C-H> <C-W>h

        " Use alt keys
        map <A-l> <C-W>l
        map <A-h> <C-W>h
        map <A-j> <C-W>j
        map <A-k> <C-W>k

    " In insert mode, use ctrl-f to fix last spelling error
        imap <c-f> <esc>mx[s1z=`xa
    " vertical split
        nmap <leader>! :vsplit<CR>
    " }



" Plugins support {
	" Use ~/.virc_bundels to load plugins
	if filereadable(expand("~/.vimrc_bundles"))
		source ~/.vimrc_bundles
	endif
" }
"
" Plugins configuration {
"
    if IsPluginInstalled("nerdtree")
        " map <leader>e  :NERDTreeToggle<CR>
        map <leader>e  :NERDTree<CR>
        map <leader>ef :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=0
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    endif
" 
" }
"
    if IsPluginInstalled("ultisnips")
        let g:UltiSnipsSnippetDirectories=["/home/natan/ultisnips", "UltiSnips"]
        let g:UltiSnipsUsePythonVersion = 3
        " let g:UltiSnipsExpandTrigger="<c-space>"
        " let g:UltiSnipsJumpForwardTrigger="<c-l>"
        " let g:UltiSnipsJumpBackwardTrigger="<c-h>"

        " :UltiSnipsEdit will to split your window.
        let g:UltiSnipsEditSplit="vertical" 
    endif
"   }
"
    if IsPluginInstalled('vim-airline')
        let g:airline#extensions#tagbar#enabled = 1
        let g:airline#extensions#tabline#enabled = 1
        set hidden
        let g:airline#extensions#tabline#fnamemod = ':t'
        let g:airline#extensions#tabline#show_tab_nr = 1
        let g:airline#extensions#tabline#buffer_idx_mode = 1
        let g:airline#extensions#tabline#show_tabs = 1
        let g:airline_left_sep = ''
        let g:airline_left_alt_sep = ''
        let g:airline_right_sep = ''
        let g:airline_right_alt_sep = ''
        let g:airline_powerline_fonts = 0
        "let g:airline_theme='jellybeans'
    endif
"
" Programming {
    " Trailing blanks
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,yaml,perl,sql autocmd BufWritePre <buffer>  call StripTrailingWhitespace() 


    " restructuredtext 
    autocmd FileType rst setlocal tw=81 foldenable spell linebreak colorcolumn=80 maxmempattern=40000
" }
"

" }

