" Modeline and Notes
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=9 foldmethod=marker spell nowrap:
"
" Cleaned environment
"
let g:plugins_dir=expand("~/.vim/plugged")
let g:python3_host_dir = expand($HOME.'/venv3/')
let g:python3_host_prog = $HOME.'/venv3/bin/python'

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
" activate python virtualenv environment for vim {
py3 << EOF
import os
import sys

if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
else:
    project_base_dir = os.path.join(os.environ['HOME'],'venv3/')

activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
with open(activate_this) as f:
    code = compile(f.read(), "activate_this.py", 'exec')
    exec(code, dict(__file__=activate_this))

os.environ['HOME']
EOF

"
" }
" Leader definition {
    let mapleader = ','
"}
"
" functions {
"

    function! IsPluginInstalled(name)
        " echom "Asked to check for: >".a:name."<"
        let s:plugin_fqpath = g:plugins_dir."/".a:name
        " Check if the Plugin is part of the runtimepath
        let s:myrtp = split((&rtp), ',')
        " echom s:myrtp
        " echom "Searching for >".s:plugin_fqpath."<"
        if matchstr(s:myrtp, s:plugin_fqpath) != ""
            " Found a bug that some plugin managers update the rtp even if
            " they where not able to install the actual plugin.
            " echom g:plugins_dir."/".a:name
            " echom isdirectory(expand(g:plugins_dir."/".a:name))
            if isdirectory(expand(g:plugins_dir."/".a:name))
                unlet s:myrtp
                return 1
            endif
        endif
        unlet s:myrtp
    endfunction
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
    " buffers
        nmap <leader>1 <Plug>AirlineSelectTab1
        nmap <leader>2 <Plug>AirlineSelectTab2
        nmap <leader>3 <Plug>AirlineSelectTab3
        nmap <leader>4 <Plug>AirlineSelectTab4
        nmap <leader>5 <Plug>AirlineSelectTab5
        nmap <leader>6 <Plug>AirlineSelectTab6
        nmap <leader>7 <Plug>AirlineSelectTab7
        nmap <leader>8 <Plug>AirlineSelectTab8
        nmap <leader>9 <Plug>AirlineSelectTab9

    " Select the whole file
        nnoremap <c-a> <esc>ggVG

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
    if IsPluginInstalled("ultisnips")
        let g:UltiSnipsSnippetDirectories=["/home/natan/ultisnips", "UltiSnips"]
        let g:UltiSnipsUsePythonVersion = 3
        " let g:UltiSnipsExpandTrigger="<c-space>"
        " let g:UltiSnipsJumpForwardTrigger="<c-l>"
        " let g:UltiSnipsJumpBackwardTrigger="<c-h>"

        " :UltiSnipsEdit will to split your window.
        let g:UltiSnipsEditSplit="vertical" 
    endif
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

    if IsPluginInstalled('ctrlp.vim')
        let g:ctrlp_map = '<p>'
    endif


"}
"
" Coc-configuration {

    if IsPluginInstalled('coc.nvim') "{
        " You will have bad experience for diagnostic messages when it's default 4000.
        set updatetime=300

        " don't give |ins-completion-menu| messages.
        set shortmess+=c

        " always show signcolumns
        set signcolumn=yes

        " Use tab for trigger completion with characters ahead and navigate.
        " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
        inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

        function! s:check_back_space() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        " Use <c-space> to trigger completion.
""        inoremap <silent><expr> <c-space> coc#refresh()

        " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
        " Coc only does snippet and additional edit on confirm.
        inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

        " Use `[c` and `]c` to navigate diagnostics
        nmap <silent> [c <Plug>(coc-diagnostic-prev)
        nmap <silent> ]c <Plug>(coc-diagnostic-next)

        " Remap keys for gotos
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)

        " Use K to show documentation in preview window
""        nnoremap <silent> K :call <SID>show_documentation()<CR>

""        function! s:show_documentation()
""          if (index(['vim','help'], &filetype) >= 0)
""            execute 'h '.expand('<cword>')
""          else
""            call CocAction('doHover')
""          endif
""        endfunction

        " Highlight symbol under cursor on CursorHold
        autocmd CursorHold * silent call CocActionAsync('highlight')

        " Remap for rename current word
        nmap <leader>rn <Plug>(coc-rename)

""        " Remap for format selected region
""        xmap <leader>f  <Plug>(coc-format-selected)
""        nmap <leader>f  <Plug>(coc-format-selected)
""
        augroup mygroup
          autocmd!
          " Setup formatexpr specified filetype(s).
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          " Update signature help on jump placeholder
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end

        " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)

        " Remap for do codeAction of current line
        nmap <leader>ac  <Plug>(coc-codeaction)
        " Fix autofix problem of current line
        nmap <leader>qf  <Plug>(coc-fix-current)

        " Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
        ""nmap <silent> <TAB> <Plug>(coc-range-select)
        ""xmap <silent> <TAB> <Plug>(coc-range-select)
        ""xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

        " Use `:Format` to format current buffer
        command! -nargs=0 Format :call CocAction('format')

        " Use `:Fold` to fold current buffer
        command! -nargs=? Fold :call     CocAction('fold', <f-args>)

        " use `:OR` for organize import of current buffer
        command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

        " Add status line support, for integration with other plugin, checkout `:h coc-status`
        set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

        " Using CocList
        " Show all diagnostics
        nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
        " Manage extensions
        nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
        " Show commands
        nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
        " Find symbol of current document
        nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
        " Search workspace symbols
        nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
        " Do default action for next item.
        nnoremap <silent> <space>j  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
        " Resume latest coc list
        nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
    endif "}

    

" }
" Programming {
    " Trailing blanks
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,yaml,perl,sql autocmd BufWritePre <buffer>  call StripTrailingWhitespace() 


    " restructuredtext 
    autocmd FileType rst setlocal tw=81 foldenable spell linebreak colorcolumn=80 maxmempattern=40000
" }
"

