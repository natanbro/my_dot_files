" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={,} foldlevel=9 foldmethod=marker nowrap:
" Python venvs ------------------------------------------------------------{{{

  let g:plugins_dir = expand('$HOME/.vim/plugged')
  let g:python3_host_prog = expand('$HOME/.vim/.venv/bin/python')
"  let g:plugins_dir = expand('~/.local/share/nvim/plugged')
"  let g:python3_host_prog = $HOME.'/.config/nvim/pyenv3/bin/python'
"}}}
"
" Leader definition {
    let mapleader = ','
"}

" functions ---------------------------------------------------------------{{{
"
  " OS_Environment {

    " Identify platform {
    " From spf13-vim [[https://vim.spf13.com/]]
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
      " let g:plugins_dir = expand('$HOME/.vim/plugged')
      " let g:python3_host_prog = expand('$HOME/.vim/.venv/bin/python')
"      let g:plugins_dir = expand('~/.local/share/nvim/plugged')
"      let g:python3_host_prog = $HOME.'/.config/nvim/pyenv3/bin/python'
    endif
    " }

    " Windows Compatible {
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier.
    if WINDOWS()
      set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
      " let g:plugins_dir = expand('~/vimfiles/plugged')
    "}}}
    endif
    " }
  " }
  "
  function! IsPluginInstalled(name)
  "  echom "Asked to check for: >".a:name."<"
  "  echom expand(g:plugins_dir."/".a:name)
    let s:myrtp = split((&rtp), ',')

    " echo   s:myrtp
      let s:plugin_fqpath = expand(g:plugins_dir."/".a:name)
      if isdirectory(s:plugin_fqpath)
      "   echo "installed ".s:plugin_fqpath

        return 1
      endif

    if WINDOWS()
      let s:plugin_fqpath = expand(g:plugins_dir."\\".a:name)
      if isdirectory(expand(g:plugins_dir."/".a:name))
        " echom "WINDOWS found plugin ".a:name
        return 1
      endif
    else
     "  e
     "  chom "Linux"

      let s:plugin_fqpath = expand(g:plugins_dir."/".a:name)

      " Check if the Plugin is part of the runtimepath
      let s:myrtp = split((&rtp), ',')
       " echom s:myrtp
       " echom "Searching for >".s:plugin_fqpath."<"
      " echom "Matching"
      " echom matchstr(s:myrtp, s:plugin_fqpath)
      " echom s:myrtp
      " echom s:plugin_fqpath

      if matchstr(s:myrtp, s:plugin_fqpath) != ""
        " Found a bug that some plugin managers update the rtp even if
        " they where not able to install the actual plugin.
          " echom "_____________________found __________________"
          " echom g:plugins_dir."/".a:name
          " echom isdirectory(expand(g:plugins_dir."/".a:name))
          " if isdirectory(expand(g:plugins_dir."/".a:name))
          unlet s:myrtp
          return 1
        endif
      endif
      unlet s:myrtp
    " endif
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
      "  echo "Warning: Unable to create backup directory: " . directory
      "  echo "Try: mkdir -p " . directory
      else
        let directory = substitute(directory, " ", "\\\\ ", "g")
        exec "set " . settingname . "=" . directory
      endif
    endfor
  endfunction
  call InitializeDirectories()

  " romainl/redir.md
  " https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
  "

  function! Redir(cmd, rng, start, end)
    for win in range(1, winnr('$'))
      if getwinvar(win, 'scratch')
        execute win . 'windo close'
      endif
    endfor
    if a:cmd =~ '^!'
      let cmd = a:cmd =~' %'
        \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
        \ : matchstr(a:cmd, '^!\zs.*')
      if a:rng == 0
        let output = systemlist(cmd)
      else
        let joined_lines = join(getline(a:start, a:end), '\n')
        let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
        let output = systemlist(cmd . " <<< $" . cleaned_lines)
      endif
    else
      redir => output
      execute a:cmd
      redir END
      let output = split(output, "\n")
    endif
    new
    let w:scratch = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    call setline(1, output)
  endfunction

  command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

  function! ToggleBg()
    let &background = ( &background == "dark"? "light" : "dark" )
  endfunction


"}}}

" My sane defaults --------------------------------------------------------{{{

  "{
      filetype plugin indent on   " Automatically detect file types.
      syntax on                   " Syntax highlighting
      set mouse=a                 " Automatically enable mouse usage
      set mousehide               " Hide the mouse cursor while typing
      scriptencoding utf-8
      " " Increment number under the cursor
      " nnoremap <A-a> <C-a>
      "
      " Clipboard
      if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
          set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
          set clipboard=unnamed
        endif
      " CTRL-Insert is Copy
       " vnoremap <C-C> "+y
        vnoremap <C-Insert> "+y
        " SHIFT-Insert is Paste
        map <S-Insert> "+gP
        imap <S-Insert>	<C-R>+
        cmap <S-Insert>	<C-R>+
      endif


      set virtualedit=onemore,block       " Allow for cursor beyond last character
      set history=1000                    " Store a ton of history (default is 20)
      set number

      set iskeyword-=.                    " '.' is an end of word designator
      set iskeyword-=#                    " '#' is an end of word designator
      set iskeyword-=-                    " '-' is an end of word designator

      set backspace=indent,eol,start  " Backspace for dummies
      set linespace=0                 " No extra spaces between rows
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

      set hidden                          " Allow buffer switching without saving
      set autowrite

      set foldenable
      set foldlevel=9
      set listchars=tab:›\ ,trail:•,eol:$,extends:#,nbsp:. " Highlight problematic whitespace
      set spell
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

      " always show signcolumns
      set signcolumn=yes

      highlight clear SignColumn      " SignColumn should match background
      highlight clear LineNr          " Current line number row will have same background color in relative mode
      set tabpagemax=15               " Only show 15 tabs
      set linespace=0                 " No extra spaces between rows
      if has('gui')
        if !WINDOWS()
            set lines=41                " 40 lines of text instead of 24
            " disable GUI menus
            set guioptions-=m
            set guioptions-=M

            " disable GUI toolbar
            set guioptions-=T           " Remove the toolbar
        endif

        if LINUX() && has("gui")
          set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 12,Consolas\ Regular\ 12,Courier\ New\ Regular\ 12
        elseif OSX() && has("gui")
          set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h16,Consolas\ Regular:h16,Courier\ New\ Regular:h16
        elseif WINDOWS() && has("gui")
          set lines=30
          set guifont=Consolas:h11,Fixedsys:h12,Andale_Mono:h12,Menlo:h12,Consolas:h12,Courier_New:h12
        endif
      endif "has GUI

      " colors
      colorscheme default
      set bg=light

      hi pmenu guibg=white

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
  " :command! Q q
  "
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
    nmap <leader>bg :call ToggleBg()<cr>

  "Split line at cursor position leaving cursor in place
    nnoremap <c-Enter> i<cr><esc>k$

  " Insert a <cr> at current cursor position
    nnoremap <Enter> a<cr><esc>

  " Allow using the repeat operator with a visual selection (!)
  " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>
  "
  "
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

  " In insert mode, use ctrl-f to fix last spelling error
    imap <c-f> <esc>mx[s1z=`xa
  " vertical split
    nmap <leader>! :vsplit<CR>
    nmap <leader>- :split<CR>
    nmap <leader>c <C-w>c

  " Terminal mode
    nmap <leader>t :e term://bash<cr>

    tmap <esc><esc> <c-\><c-n>

    tmap <c-j> <C-\><C-n>:bnext<cr>
    tmap <c-k> :<C-\><C-n>bprevious<cr>

  " Easy change between Windows
    tmap <C-L> <<C-\><C-n>C-W>l
    tmap <C-H> <C-\><C-n><C-W>h

      " Use alt keys
    tmap <A-l> <C-\><C-n><C-W>l
    tmap <A-h> <C-\><C-n><C-W>h
    tmap <A-j> <C-\><C-n><C-W>j
    tmap <A-k> <C-\><C-n><C-W>k


"}}}

" Setup Vim-Plug ----------------------------------------------------------{{{
  call plug#begin(g:plugins_dir)

" aux
"  Plug 'Shougo/vimproc.vim', {'do' : 'make'}
"  Plug 'xolox/vim-misc'
"""  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'

" syntax
  Plug 'sheerun/vim-polyglot'
"  Plug 'benekastah/neomake'
  Plug 'https://github.com/vim-syntastic/syntastic'

" IDE
  Plug 'itchyny/vim-cursorword' " highlight word under cursor
  Plug 'scrooloose/nerdtree'
  Plug 'https://github.com/tomtom/tcomment_vim'
  Plug 'godlygeek/tabular'
  Plug 'junegunn/vim-easy-align'
"  Plug 'luochen1990/rainbow'
"  if executable('ctags')
"      Plug 'majutsushi/tagbar'
"  endif
  Plug 'vim-scripts/IndexedSearch'
"  Plug 'vim-scripts/YankRing.vim'
  Plug 'https://github.com/adelarsq/vim-matchit'
  " Plug 'embear/vim-localvimrc'
  "
" buffer management
  Plug 'moll/vim-bbye'

  " use terminals as buffers
  Plug 'rosenfeld/conque-term'
  "
  " Window selector
"  Plug 't9md/vim-choosewin'
  "

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
  Plug 'https://github.com/vim-scripts/autumnleaf_modified.vim.git'
  Plug 'https://github.com/baeuml/summerfruit256.vim.git'
  Plug 'https://github.com/datMaffin/vim-colors-bionik.git'
  Plug 'https://github.com/yasukotelin/shirotelin.git'
"  Plug 'https://github.com/sonph/onehalf.git'
"  Plug 'https://github.com/dracula/dracula-theme.git'
  Plug 'sonph/onehalf', {'rtp': 'vim/'}
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'patstockwell/vim-monokai-tasty'

  " Override configurations using .vim.custom files
"  " Plug 'arielrossanigo/dir-configs-override.vim'

" git
  Plug 'tpope/vim-fugitive'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'airblade/vim-gitgutter'

" decorate
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

" autocomplete

"  Plug 'junegunn/fzf'
"  Plug 'junegunn/fzf.vim'
"  Plug 'https://github.com/kien/ctrlp.vim.git'
  Plug 'https://github.com/ctrlpvim/ctrlp.vim'

  Plug 'Shougo/deoplete.nvim'
  Plug 'deoplete-plugins/deoplete-jedi'
  " Completion from other opened files
  Plug 'Shougo/context_filetype.vim'
" Just to add the python go-to-definition and similar features, autocompletion
" from this plugin is disabled
  Plug 'davidhalter/jedi-vim'

  " NB: snippets
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'



" Language Servers
"  Plug 'neoclide/coc.nvim', {'branch': 'release'}


" movement
  Plug 'tpope/vim-surround'
  Plug 'easymotion/vim-easymotion'
  " Plug 'https://github.com/unblevable/quick-scope.git'
  Plug 'https://github.com/tpope/vim-repeat.git'

" denite
  """ NB: Plug 'Shougo/denite.nvim'
  """ NB: Plug 'nixprime/cpsm'

" config
  Plug 'editorconfig/editorconfig-vim'

" CSS Colors
  Plug 'https://github.com/lilydjwg/colorizer.git'

" Python
"  Plug 'python/black'

" yaml
  Plug 'stephpy/vim-yaml'
  "
  " JSON
  " Check out these must have mappings for working with JSON in Vim:"
  Plug 'https://github.com/tpope/vim-jdaddy'

  "
  " rst
  " Plug 'https://github.com/Rykka/riv.vim.git'
  "
" Markdown
  Plug 'https://github.com/plasticboy/vim-markdown/'
  Plug 'https://github.com/previm/previm/'
  Plug 'https://github.com/tyru/open-browser.vim'
  " Plug 'https://github.com/instant-markdown/vim-instant-markdown.git'

" Golang
  " Plug 'https://github.com/fatih/vim-go'

 " Highlight current paragraph
  Plug 'junegunn/limelight.vim'

  " Distraction free writing
  Plug 'junegunn/goyo.vim'

" wiki
"   Plug 'https://github.com/vimwiki/vimwiki'
  Plug 'https://github.com/vim-voom/VOoM'
  Plug 'https://github.com/vimoutliner/vimoutliner'

" finish set up
  call plug#end()
  filetype plugin indent on

"}}}




" Plugins configuration ---------------------------------------------------{{{
"
" VOoM
if IsPluginInstalled("VOoM")
  let g:voom_python_versions = [3]
endif

" Use deoplete.
if IsPluginInstalled("deoplete")
    let g:deoplete#enable_at_startup = 1
    call deoplete#custom#option({
    \   'ignore_case': v:true,
    \   'smart_case': v:true,
    \})
    " complete with words from any opened file
    let g:context_filetype#same_filetypes = {}
    let g:context_filetype#same_filetypes._ = '_'

endif



" Jedi-vim
if IsPluginInstalled("jedi-vim")

    " Disable autocompletion (using deoplete instead)
    let g:jedi#completions_enabled = 0

    " All these mappings work only for python code:
    " Go to definition
    let g:jedi#goto_command = ',d'
    " Find ocurrences
    let g:jedi#usages_command = ',o'
    " Find assignments
    let g:jedi#goto_assignments_command = ',a'
    " Go to definition in new tab
    nmap ,D :tab split<CR>:call jedi#goto()<CR>
endif



if IsPluginInstalled("nerdtree")
" echo "Checking for Nerdtree"
" g:installed_nerdtree =

" if exists("g:loaded_nerd_tree")
" echo "Checking for Nerdtree"

    function! IsNerdTreeEnabled()
      return exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
    endfunction

    function! NERDTreeFindToggle()
      if IsNerdTreeEnabled()
        " Check if NerdTree is the current buffer
        if @% == t:NERDTreeBufName
          " If Nerdtree is selected and the current buffer, goto the
          " window it was open before entering NERDTree
          wincmd w
        else
          :NERDTreeFind
        endif
"        :NERDTreeClose
      else
        :NERDTree
        wincmd w
        :NERDTreeFind
      endif
    endfunction
    " nnoremap <silent> <leader>e :call NERDTreeFindToggle()<CR>

    "map <leader>e  :NERDTree<CR>
    "map <leader>ef :NERDTreeFind<CR>
    nnoremap <silent> <leader>e :NERDTreeToggle<CR>
    "
    " Exit Vim if NERDTree is the only window remaining in the only tab.
    "
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    "
    "Close the tab if NERDTree is the only window remaining in it.
    "
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
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
    let g:UltiSnipsSnippetDirectories=["~/ultisnips", "UltiSnips"]
    let g:UltiSnipsEditSplit="vertical"
  endif
"
if IsPluginInstalled('vim-airline')
"if exists("g:loaded_airline")
    " echo "Configurating airline"
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

    tmap <leader>1  <C-\><C-n><Plug>AirlineSelectTab1
    tmap <leader>2  <C-\><C-n><Plug>AirlineSelectTab2
    tmap <leader>3  <C-\><C-n><Plug>AirlineSelectTab3
    tmap <leader>4  <C-\><C-n><Plug>AirlineSelectTab4
    tmap <leader>5  <C-\><C-n><Plug>AirlineSelectTab5
    tmap <leader>6  <C-\><C-n><Plug>AirlineSelectTab6
    tmap <leader>7  <C-\><C-n><Plug>AirlineSelectTab7
    tmap <leader>8  <C-\><C-n><Plug>AirlineSelectTab8
    tmap <leader>9  <C-\><C-n><Plug>AirlineSelectTab9

  endif

  if IsPluginInstalled('ctrlp.vim')
    nmap <c-p> :CtrlP<cr>

  endif

  if IsPluginInstalled('vim-localvimrc')
    let g:localvimrc_sandbox = 0
    let g:localvimrc_ask = 0
    let g:localvimrc_enable = 1
  endif

  if IsPluginInstalled("black")
    " let g:black_virtualenv=g:python3_host_prog
    let g:black_linelength = 78
    let g:black_skip_string_normalization = 1
  endif


 " Programming {
     " Trailing blanks
     autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,yaml,perl,sql autocmd BufWritePre <buffer>  call StripTrailingWhitespace()
     autocmd FileType yaml,yml,vim autocmd BufWritePre <buffer>  call StripTrailingWhitespace()

     " restructuredtext
     autocmd FileType rst setlocal tw=81 foldenable spell linebreak colorcolumn=80 maxmempattern=40000
 " }
 "
 "
 " Syntatic {
  if IsPluginInstalled("syntastic")

    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    set signcolumn=yes
    " let g:syntastic_markdown_checkers = ['syntastic-markdown-mdl', 'syntastic-markdown-proselint','syntastic-markdown-textlint']
    let g:syntastic_markdown_mdl_exec = "~/.npm-packages/markdownlint.cmd"
    let g:syntastic_markdown_mdl_args = "%"

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    " let g:syntastic_debug = 33

  endif

 " }
 "}}}


" Python development ------------------------------------------------------{{{

"}}}

  " Depolete --------------------------------------------------------------{{{

  " }}}
  "
 :highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
 :au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
 :au InsertLeave * match ExtraWhitespace /\s\+$/

 " Previm {
   if WINDOWS()
     let g:previm_open_cmd = 'start firefox'
   else
     " let g:previm_open_cmd = 'open -a Firefox'
   endif
 " {

 " Markdown {
 "
 "

  function! MdSetColors()
    colorscheme PaperColor
    set bg=light
  endfunction

  function! MdBuffer()
    let g:mdbuffer=1
    if WINDOWS()
      set fileformat=unix
    endif
    set fileencoding=utf-8
    set encoding=utf-8
    set spell
    set wrap
"    set colorcolumn=80
    " set textwidth=79
    set textwidth=3000
    set linebreak
    set sw=4
    set ts=4
  endfunction
 " }
 "

let g:previm_open_cmd = 'start Firefox'

function! Mde_spanish()

  " Markdown in spanish
  let g:mdspanish=1
  setl filetype=markdown
  setl fileencoding=utf-8
  setl encoding=utf-8
  setl spell
  setl spelllang=es
"  setl breakat=79
  setl wrap
  setl textwidth=3000
  " setl linebreak
"  setl breakindent
  setl sw=4
  setl ts=4
  call SpanishMap()
endfunc

function! SpanishMap()
  inoremap << «
  inoremap >> »

  inoremap 'a á
  inoremap 'A Á
  inoremap 'e é
  inoremap 'E É
  inoremap 'i í
  inoremap 'I Í
  inoremap 'o ó
  inoremap 'O Ó
  inoremap 'u ú
  inoremap 'U Ú
  inoremap ~n ñ
  inoremap nn ñ
  inoremap ~N Ñ
  inoremap NN Ñ
  inoremap :u ü
  inoremap :U Ü
  inoremap ?? ¿
  inoremap !! ¡
  inoremap -- –
  inoremap 'c ción
endfunc

function! EnableSpanishMarkdown()
  " Check if the file named "md_spanish" exists in the current directory
  let s:filename_for_spanish_md="md_spanish"
  " let s:current_ext=expand('%:e')
  " echo expand('%:p:h')."/".s:filename_for_spanish_md
  let s:file_to_check=expand('%:p:h')."/".s:filename_for_spanish_md
  " echo s:file_to_check
  " echo "Current extension and path"
  " echo s:current_ext
  " echo s:current_filepath
  " if s:current_ext == "md"
    " echo "Checking for file"
    " let s:file_to_check=s:current_filepath . s:filename_for_spanish_md
    " echo s:file_to_check
    " if exists(expand(s:filename_for_spanish_md))
    if filereadable(expand(s:file_to_check))
      " echo "found"
      call Mde_spanish()
      call MdSetColors()
    else
      " echo "Notfound"
    endif
endfunc

aug mde
   au!
   autocmd! BufRead,BufNewFile *.{mde,mds,mdspanish} call Mde_spanish()
   autocmd BufWritePre <buffer>  call StripTrailingWhitespace()
augroup end

aug markdown
   au!
   "set filetype=markdown
   autocmd BufRead,BufNewFile *.{md,markdown} call MdBuffer() | call EnableSpanishMarkdown()
   autocmd BufWritePre <buffer>  call StripTrailingWhitespace()
   " call EnableSpanishMarkdown()
   " echo "In a markdown file"
augroup end


autocmd ColorScheme * :highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
" colorscheme dracula
colorscheme vim-monokai-tasty
set bg=dark

 " }
" vim: set tabstop=2 shiftwidth=2 expandtab:
