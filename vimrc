" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={,} foldlevel=9 foldmethod=marker nowrap:
" Python venvs ------------------------------------------------------------{{{

  let g:plugins_dir = expand('~/.local/share/nvim/plugged')
  let g:python_host_prog = $HOME.'/.config/nvim/pyenv2/bin/python'
  let g:python3_host_prog = $HOME.'/.config/nvim/pyenv3/bin/python'
"}}}
"
" Leader definition {
    let mapleader = ','
"}

" functions ---------------------------------------------------------------{{{
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

  " Plug {
  function! UpgradePlugins()
    " TODO: update packages in nvim pyenvs
    " upgrade vim-plug itself
    :PlugUpgrade
    " upgrade the vim-go binaries
    :call GoUpdateBinaries()
    " upgrade the plugins
    :PlugUpdate
  endfunction
  nnoremap <silent> <leader>u :call UpgradePlugins()<CR>
  "}

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

"}}}

" My sane defaults --------------------------------------------------------{{{

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
    "
  " Status line {
      set ruler                   " Show the ruler
      set showcmd                 " Show partial commands in status line and
                                  " Selected characters/lines in visual mode
      set showmode                " Display the current mode
      set laststatus=2
      set wildmenu                    " Show list instead of just completing
      set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
      set colorcolumn=79
  " }

"}}}
"
" Disable common typos-----------------------------------------------------{{{
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
"}}}


" Useful mappings ---------------------------------------------------------{{{
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
"}}}

" Setup Vim-Plug ----------------------------------------------------------{{{
  call plug#begin(g:plugins_dir)

" aux
  Plug 'Shougo/vimproc.vim', {'do' : 'make'}
  Plug 'xolox/vim-misc'
  Plug 'embear/vim-localvimrc'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'

" syntax
  Plug 'sheerun/vim-polyglot'
  Plug 'benekastah/neomake'

" buffer management
  Plug 'moll/vim-bbye'

" color
  Plug 'nanotech/jellybeans.vim'
  Plug 'https://github.com/natanbro/browny_vim.git'
  Plug 'altercation/vim-colors-solarized'
  Plug 'spf13/vim-colors'
  Plug 'https://github.com/reedes/vim-colors-pencil.git'
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'muellan/am-colors'
  Plug 'josuegaleas/jay'
  Plug 'morhetz/gruvbox'
  Plug 'mkarmona/materialbox'

" git
  Plug 'tpope/vim-fugitive'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'airblade/vim-gitgutter'

" decorate
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

" autocomplete
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'https://github.com/kien/ctrlp.vim.git'

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'xolox/vim-lua-ftplugin', { 'for': 'lua' } " lua

" snippets
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'

" IDE
  Plug 'itchyny/vim-cursorword' " highlight word under cursor
  Plug 'scrooloose/nerdtree'
  " Plug 'powerman/vim-plugin-viewdoc' " Doc integration
  Plug 'https://github.com/tomtom/tcomment_vim'
  Plug 'godlygeek/tabular'
  Plug 'luochen1990/rainbow'
  if executable('ctags')
      Plug 'majutsushi/tagbar'
  endif
  Plug 'https://github.com/adelarsq/vim-matchit'

" Language Servers

  " The reason we use a function is because we want to get the event
  " even if the package is unchanged as the updates are not tracked in
  " this repo
  function! BuildPyls(info)
    !./install.sh
  endfunction
  Plug 'ficoos/pyls-vimplug', { 'do': function('BuildPyls') }

  function! BuildCCLS(info)
    !cmake -H. -BRelease && cmake --build Release
  endfunction
  Plug 'MaskRay/ccls', { 'do': function('BuildCCLS') }

" movement
  Plug 'tpope/vim-surround'
  Plug 'ficoos/plumb.vim'
  Plug 'easymotion/vim-easymotion'
  Plug 'https://github.com/tpope/vim-repeat.git'

" denite
  Plug 'Shougo/denite.nvim'
  Plug 'nixprime/cpsm'

" config
  Plug 'editorconfig/editorconfig-vim'

" Python
  Plug 'python/black'

" yaml
  Plug 'stephpy/vim-yaml'
  "
  " rst
  " Plug 'https://github.com/Rykka/riv.vim.git'

" finish set up
  call plug#end()
  filetype plugin indent on

"}}}


" Plugins configuration ---------------------------------------------------{{{
"
  if IsPluginInstalled("nerdtree")
    function! IsNerdTreeEnabled()
      return exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
    endfunction

    function! NERDTreeFindToggle()
      if IsNerdTreeEnabled()
        :NERDTreeClose
      else
        :NERDTreeFind
      endif
    endfunction
    nnoremap <silent> <leader>e :call NERDTreeFindToggle()<CR>

    "map <leader>e  :NERDTree<CR>
    "map <leader>ef :NERDTreeFind<CR>

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
    nmap <c-p> :CtrlP<cr>

  endif

  if IsPluginInstalled("black") && executable('black')
    let g:black_linelength = 78
    let g:black_skip_string_normalization = 1
  endif

 " Programming {
     " Trailing blanks
     autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,yaml,perl,sql autocmd BufWritePre <buffer>  call StripTrailingWhitespace()
     autocmd FileType yaml,yml,md,vim autocmd BufWritePre <buffer>  call StripTrailingWhitespace()

     " restructuredtext
     autocmd FileType rst setlocal tw=81 foldenable spell linebreak colorcolumn=80 maxmempattern=40000
 " }
 "
 "}}}


" Python development ------------------------------------------------------{{{

  let g:neomake_python_enabled_makers = [] " we use LSP

"}}}


  " Denite ----------------------------------------------------------------{{{
  if IsPluginInstalled('denite.nvim')
    call denite#custom#option('default', 'prompt', '»')
    call denite#custom#option('default', 'auto-resize', 1)
    call denite#custom#option('default', 'direction', 'botright')
    call denite#custom#source('default', 'matchers', ['matcher_cpsm'])

    " Change mappings.
    call denite#custom#map(
          \ 'insert',
          \ '<down>',
          \ '<denite:move_to_next_line>',
          \ 'noremap'
          \)
    call denite#custom#map(
          \ 'insert',
          \ '<up>',
          \ '<denite:move_to_previous_line>',
          \ 'noremap'
          \)

    function! CtrlP()
      call denite#start(b:ctrlp_sources)
    endfunction

    function! DetectSources()
      if exists('b:ctrlp_sources')
        return
      endif

      let b:ctrlp_sources = []
      silent! !git status
      if v:shell_error == 0
        call add(b:ctrlp_sources, {'name': 'git', 'args': []})
        call add(b:ctrlp_sources, {'name': 'git-other', 'args': []})
        silent! !git config --file .gitmodules --list
        if v:shell_error == 0
          call add(b:ctrlp_sources, {'name': 'git-submodules', 'args': []})
        endif
      else
        call add(b:ctrlp_sources, {'name': 'file/rec', 'args': []})
      endif
    endfunction

""":   au BufEnter * call DetectSources()
""":   nnoremap <silent> <c-p> :call CtrlP() <CR>
""":   nnoremap <silent> <c-j> :Denite -auto-resize -direction=botright location_list<CR>
""":   nnoremap <silent> <a-p> :DeniteCursorWord -auto-resize -direction=botright grep<CR>
""":   nnoremap <silent> <a-s-p> :Denite -auto-resize -direction=botright grep<CR>
""":   nnoremap <silent> <c-a-o> :Denite -auto-resize -direction=botright outline<CR>
""":   nnoremap <leader>\ :Denite -auto-resize -direction=botright command<CR>

""   call denite#custom#alias('source', 'git', 'file/rec')
""   call denite#custom#var('git', 'command',
""         \['git',
""         \ 'ls-files',
""         \ '-c'])
""
""   call denite#custom#alias('source', 'git-other', 'file/rec')
""   call denite#custom#var('git-other', 'command',
""         \['git',
""         \ 'ls-files',
""         \ '-o',
""         \ '--exclude-standard'])
""
""   call denite#custom#alias('source', 'git-submodules', 'file/rec')
""   call denite#custom#var('git-submodules', 'command',
""         \['sh', '-c',
""         \ 'git config --file .gitmodules --get-regexp path | cut -d " " -f2- | xargs git ls-files --recurse-submodules'])
""
""   call denite#custom#var('file/rec', 'command',
""         \['ag',
""         \'--follow',
""         \'--nocolor',
""         \'--nogroup',
""         \'-g', ''])
  endif
  "}}}

  " Depolete --------------------------------------------------------------{{{
 if IsPluginInstalled('deoplete.nvim')
   set completeopt=menuone,noinsert
   let g:deoplete#enable_at_startup = 1
   let g:deoplete#auto_completion_start_length = 1
   let g:deoplete#enable_smart_case = 1
   " set omni complete
   if !exists('g:deoplete#omni#input_patterns')
     let g:deoplete#omni#input_patterns = {}
   endif
   call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])

   " Close the documentation window when completion is done
   autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    """":  if !exists('g:deoplete#sources')
    """":    let g:deoplete#sources={}
    """":  endif
    """":  let g:deoplete#sources._=['buffer', 'file', 'ultisnips']
    """":  let g:deoplete#sources.python=['buffer', 'file', 'ultisnips', 'LanguageClient']
    """":  let g:deoplete#sources.rust=['ultisnips', 'LanguageClient']
    """":  let g:deoplete#sources.cpp=['ultisnips', 'LanguageClient']
    """":  let g:deoplete#sources.c=['ultisnips', 'LanguageClient']
    """":  let g:deoplete#sources.go=['ultisnips', 'LanguageClient']
    """":
    """":  let g:LanguageClient_hasSnippetSupport = 0
    """":

  endif
  " }}}
  "
 function! SetLSPShortcuts()
   nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
   nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
   nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
   nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
   nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
   nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
   nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
   nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
   nnoremap <leader>ls :Denite -auto-resize -direction=botright documentSymbol<CR>
   nnoremap <leader>lS :Denite -auto-resize -direction=botright workspaceSymbol<CR>
   nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>

   nnoremap <F1> :Denite -auto-resize -direction=botright contextMenu<CR>
   nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
 endfunction()
"""
 augroup LSP
   autocmd!
   autocmd FileType cpp,c,go,rust,python call SetLSPShortcuts()
 augroup END

 let g:LanguageClient_serverCommands = {
  \ 'rust':   ['rls'],
  \ 'c'   :   [g:plug_home.'/ccls/Release/ccls'],
  \ 'cpp' :   [g:plug_home.'/ccls/Release/ccls'],
  \ 'go'  :   ['bingo'],
  \ 'python': [g:plug_home.'/pyls-vimplug/pyls'],
  \ }
"   ""}}}

 nmap <F12> :nohl<CR>:call LanguageClient_clearDocumentHighlight()<CR>

 :highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
 :au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
 :au InsertLeave * match ExtraWhitespace /\s\+$/
" vim: set tabstop=2 shiftwidth=2 expandtab:
