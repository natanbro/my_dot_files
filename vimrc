" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
" Environment {

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

    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }
    " Use bundles_pre config {
        if filereadable(expand("~/.vimrc_bundles_pre"))
            source ~/.vimrc_bundles_pre
        endif
    " }
    "
    " Load project specific configuration before loading plugins
    " project_pre.vim {
        if filereadable("./project_pre.vim")
            source ./project_pre.vim
        endif
    " }

    " Setup Bundle Support {
        " The next three lines ensure that the ~/.vim/bundle/ system works
        filetype off
        set rtp+=~/.vim/bundle/Vundle.vim
        " " " " " " call vundle#rc()
        call vundle#begin() " 
    " }

    " Add an UnBundle command {
    function! UnBundle(arg, ...)
      let bundle = vundle#config#init_bundle(a:arg, a:000)
      call filter(g:vundle#bundles, 'v:val["name_spec"] != "' . a:arg . '"')
    endfunction

    com! -nargs=+         UnBundle
    \ call UnBundle(<args>)
    " }

" Abbreviations {
"
"   Global abbreviations
    if filereadable(resolve(expand("~/abbreviations.vim")))
        source ~/abbreviations.vim
    endif
"
"
"   Local directory is checked
    if filereadable(resolve(expand("./abbreviations.vim")))
        source ./abbreviations.vim
    endif

" }
"
" }

" } Environment
" Disable arrow keys {
    inoremap  <Up>     <NOP>
    inoremap  <Down>   <NOP>
    inoremap  <Left>   <NOP>
    inoremap  <Right>  <NOP>
    noremap   <Up>     <NOP>
    noremap   <Down>   <NOP>
    noremap   <Left>   <NOP>
    noremap   <Right>  <NOP>
" }

" General {
    let mapleader = ','

    set background=dark         " Assume a dark background

    " Allow to trigger background
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    noremap <leader>bg :call ToggleBG()<CR>

    " if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    " endif
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

    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
"    set virtualedit=onemore             " Allow for cursor beyond last character
    set virtualedit=onemore,block       " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set nospell                         " Spell checking off
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.before.local file:
        "   let g:spf13_no_views = 1
        " Add exclusions to mkview and loadview
        " eg: *.*, svn-commit.tmp
        let g:skipview_files = [
            \ '\[example pattern\]'
            \ ]
    " }

" }  // General



" Use bundles config {
    if filereadable(expand("~/.vimrc_bundles"))
        source ~/.vimrc_bundles
    endif
" }
"
" Specific Bundle Configuration {
"   Syntactics {
 
        if filereadable(expand("~/.vim/bundle/syntastic/plugin/syntastic.vim"))
            " echo "syntactic"
            let g:syntastic_rst_checkers = ['rstcheck']
            let g:syntastic_yaml_checkers = ['yamllint']
            let g:syntastic_json_checkers = ['jsonlint']

            set statusline+=%#warningmsg#
            set statusline+=%{syntasticstatuslineflag()}
            set statusline+=%*

            let g:syntastic_always_populate_loc_list = 1
            let g:syntastic_auto_loc_list = 1
            let g:syntastic_check_on_open = 1
            let g:syntastic_check_on_wq = 0
        endif
"   }
" }
"

" vim ui {
    set cursorline                  " highlight current line

    highlight clear signcolumn      " signcolumn should match background
    highlight clear linenr          " current line number row will have same background color in relative mode
"
    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        if !exists('g:override_spf13_bundles')
            if !exists('~/.vim/bundle/vim-fugitive')
                set statusline+=%{fugitive#statusline()} " Git Hotness
            endif
        endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif
"
    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set nofoldenable                " by default, don't fold code
    "set list
    "set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
    "set listchars=tab:»\            " Tab is <c-k> >>
    set listchars=trail:•,extends:#,nbsp:.      " list characters
    set listchars=eol:¬,tab:»\ ,trail:•,extends:#,nbsp:.    "             " eol <c-k> -,
    set nowrapscan                  " stop search at the end of the file
    set belloff=all                 " Completely disable the bell for errors and pressing "ESC" on normal mode 

" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    " nmap <F11> :set pastetoggle<CR> " pastetoggle (sane indentation on pastes)
    map <F11>:set invpaste<CR>        " same as pastetoggle

    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    autocmd FileType sls,yml,salt autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif

    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd FileType sls,salt,yml,yaml setlocal expandtab shiftwidth=2 softtabstop=2 foldmethod=indent foldenable colorcolumn=80


" markdown {
    autocmd FileType markdown setlocal tw=81 bg=light foldenable spell linebreak colorcolumn=80
" }

" restructuredtext {
    autocmd FileType rst setlocal tw=81 foldenable spell linebreak colorcolumn=80
" }
" Vimoutline {
    autocmd FileType votl setlocal spell nolist foldenable
" }

" Key (re)Mappings {
    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    "
"     map <C-J> <C-W>j
"     map <C-K> <C-W>k
"     map <C-L> <C-W>l
"     map <C-H> <C-W>h
" 
"     "leader moves between buffers
"     nmap <leader>j :bprevious<CR>
"     nmap <leader>k :bnext<CR>
"     nmap <leader>del :bdelete!<CR>
"     nmap <leader>h :bprevious<CR>
"     nmap <leader>l :bnext<CR>

"    " J,K moves between buffers
"    map <C-J> :bprevious<CR>
"    map <C-K> :bnext<CR>
"    " l,h moves between windows
"    map <C-L> <C-W>l
"    map <C-H> <C-W>h
"
"    Control hjkl moves between buffers
    nnoremap <C-h> :bprevious<CR>
    nnoremap <C-j> :bprevious<CR>
    nnoremap <C-k> :bnext<CR>
    nnoremap <C-l> :bnext<CR>
"
"    Control arrows  moves between Windows
    nnoremap <C-Left> <C-W>h
    nnoremap <C-Right> <C-W>l
    nnoremap <C-Up>  <C-W>k
    nnoremap <C-Down> <C-W>j

"

    "leader moves between buffers
    nmap <leader>del :bdelete!<CR>

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    nnoremap Y y$

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

    nmap <silent> <leader>/ :set invhlsearch<CR>

    nmap <silent><leader>\  :set invspell<CR>

    " Create vertical split with same combination as in tmux
    nmap <leader>%  :vsplit<CR>

    imap <c-f> <c-g>u<Esc>[s1z=`]a<c-g>u
    nmap <c-f> [s1z=<c-o>

    " move the line with the cursor one line down by inserting a blank line on
    " top of the current line
    nmap <A-Down>   :normal O<ESC>j
    imap <A-Down>   <ESC>mmO<ESC>j`ma
    "
    " move the line with the cursor one line up deleting the line on the line
    " on top of the cursor
    nmap <A-Up>   kdd
    imap <A-Up>   <ESC>mmlkdd`ma


    "Mappings to move lines without adding nor removing the total lines in the
    "file. See: http://vim.wikia.com/wiki/Moving_lines_up_or_down
    "
	nnoremap <A-j> :m .+1<CR>==
	nnoremap <A-k> :m .-2<CR>==
	inoremap <A-j> <Esc>:m .+1<CR>==gi
	inoremap <A-k> <Esc>:m .-2<CR>==gi
	vnoremap <A-j> :m '>+1<CR>gv=gv
	vnoremap <A-k> :m '<-2<CR>gv=gv
    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>


    map <C-N>   :redraw <cr>

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <leader>e  :NERDTreeToggle<CR>
            map <leader>ef :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
        endif
    " }



" }

"
" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if !exists("g:spf13_no_big_font")
            if LINUX() && has("gui_running")
                " echom "Setting font linux"
                " set guifont=Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 16,Consolas\ Regular\ 16,Courier\ New\ Regular\ 16
                set guifont=Monospace\ 12
            elseif OSX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular:h13,Menlo\ Regular:h13,Consolas\ Regular:h13,Courier\ New\ Regular:h14
                " echom "Setting font osx"

            elseif WINDOWS() && has("gui_running")
                set guifont=Andale_Mono:h12,Menlo:h12,Consolas:h12,Courier_New:h12
                " echom "Setting font windows"
            endif
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {

    " Initialize directories {
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

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                " echo "Warning: Unable to create backup directory: " . directory
                " echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }

    " Strip whitespace {
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
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }

     
    function! s:ExpandFilenameAndExecute(command, file)
        execute a:command . " " . expand(a:file, ":p")
    endfunction
     
" }
"
" Paragraph sorting function {
"	See: http://stolarscy.com/dryobates/2014-05/sorting_paragraphs_in_vim/
"
	function! SortParagraphs() range
		execute a:firstline . "," . a:lastline . 'd'
		let @@=join(sort(split(substitute(@@, "\n*$", "", ""), "\n\n")), "\n\n")
		put!
	endfunction

" }
"
"

" MyOwnMappings {
"
    if filereadable(expand("~/.vim/bundle/vim-colors/colors/molokai.vim"))
        color molokai             " Load a colorscheme
    endif

    if filereadable(expand("~/.vim/bundle/vim-lucius/colors/lucius.vim"))
        let g:lucius_style="light"
        " Set this option to either 'light' or 'dark' for your desired 
        " color scheme.
        let g:lucius_contrast='high'
"
        " This option determines the contrast to use for text/ui elements. It can be
        " set to 'low', 'normal', or 'high'. At this time there is no 'high' for the
        " light scheme.
        let g:lucius_contrast_bg='high'
    endif

" }
"
"  Fix colors for Visual Selection and cursor line {
"
    function! FixColors()
        hi Visual term=reverse cterm=reverse guibg=Grey
        hi CursorLine cterm=NONE ctermbg=240
        hi Comment guifg=#E6DB74
    endfunction

    call FixColors()
"}




" Use local gvimrc if available and gui is running {
    if has('gui_running')
        if filereadable(expand("~/.gvimrc.local"))
            source ~/.gvimrc.local
        endif
    endif
" }

" }
"
" FixPaperColorScheme {
    function! FixPaperColorScheme()
        if filereadable(expand("/home/natan/projects/others/nb_repos/my_dot_files/vim/bundle/papercolor-theme/colors/PaperColor.vim"))
            set background=light
            color PaperColor        " Load a colorscheme
            :highlight SpellBad ctermfg=009 ctermbg=011 guifg=#ff0000 guibg=#ffff00
        endif
    endfunction
" }
"
" Load project specific configuration {
"   If a file named .project.vim exist in the local directory, it is sourced
"   to provide specific configuration options for the project.
"   Only local directory is checked
    if filereadable("./project.vim")
        source ./project.vim
        "echo "project.vim loaded"
        "    else
        "        echom expand('%:p')
    endif
"    }
" revealSyntaxTag {

    " adds to statusline
    if has('statusline')
        set laststatus=2
        set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}
    endif

    " a little more informative version of the above
    nmap <Leader>sI :call <SID>SynStack()<CR>

    function! <SID>SynStack()
        if !exists("*synstack")
            return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    endfunc
"    }
"
