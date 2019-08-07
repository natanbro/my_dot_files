" Python venvs ------------------------------------------------------------{{{

  let g:python_host_prog = $HOME.'/.config/nvim/pyenv2/bin/python'
  let g:python3_host_prog = $HOME.'/.config/nvim/pyenv3/bin/python'
"}}}

" Setup Vim-Plug ----------------------------------------------------------{{{
  call plug#begin('~/.local/share/nvim/plugged')

" aux
  Plug 'Shougo/vimproc.vim', {'do' : 'make'}
  Plug 'xolox/vim-misc'
  Plug 'embear/vim-localvimrc'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'

" syntax
  Plug 'sheerun/vim-polyglot'
  Plug 'benekastah/neomake'
  "Plug 'rust-lang/rust.vim'

" buffer management
  Plug 'moll/vim-bbye'

" color
  Plug 'nanotech/jellybeans.vim'

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
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'xolox/vim-lua-ftplugin', { 'for': 'lua' } " lua

" snippets
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'

" IDE
  Plug 'itchyny/vim-cursorword' " highlight word under cursor
  Plug 'scrooloose/nerdtree'
  Plug 'powerman/vim-plugin-viewdoc' " Doc integration
  Plug 'majutsushi/tagbar'
  Plug 'Shougo/echodoc.vim'

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

" denite
  Plug 'Shougo/denite.nvim'
  Plug 'nixprime/cpsm'

" config
  Plug 'editorconfig/editorconfig-vim'

" finish set up
  call plug#end()
  filetype plugin indent on

"}}}

" Python development ------------------------------------------------------{{{

  let g:neomake_python_enabled_makers = [] " we use LSP

"}}}

" Go development ------------------------------------------------------{{{

  let g:neomake_go_enabled_makers = [] " we use LSP
  function GoUpdateBinaries()
    !go get -u github.com/saibing/bingo
  endfunction


"}}}

" C/C++ Development -------------------------------------------------------{{{

  let g:c_syntax_for_h=1
  let g:neomake_c_enabled_makers = [] " we use LSP
  let g:neomake_cpp_enabled_makers = [] " we use LSP
"}}}

" General -----------------------------------------------------------------{{{

" colors
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0
  set colorcolumn=79
  "let loaded_matchparen = 1

" search
  set hlsearch
  set smartcase
  set incsearch

  if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
  endif

" line numbering
  set number
  set cursorline

" ide like save-on-build
  set autowrite
"}}}

" Plug --------------------------------------------------------------------{{{
  function UpgradePlugins()
    " TODO: update packages in nvim pyenvs
    " upgrade vim-plug itself
    :PlugUpgrade
    " upgrade the vim-go binaries
    :call GoUpdateBinaries()
    " upgrade the plugins
    :PlugUpdate
  endfunction
  nnoremap <silent> <leader>u :call UpgradePlugins()<CR>
"}}}

" echodoc -----------------------------------------------------------------{{{
  set cmdheight=2
  let g:echodoc#enable_at_startup = 1
  let g:echodoc#type = 'signature'
"}}}

" Denite ------------------------------------------------------------------{{{

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

  function CtrlP()
    call denite#start(b:ctrlp_sources)
  endfunction

  function DetectSources()
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

  au BufEnter * call DetectSources()
  nnoremap <silent> <c-p> :call CtrlP() <CR>
  nnoremap <silent> <c-j> :Denite -auto-resize -direction=botright location_list<CR>
  nnoremap <silent> <a-p> :DeniteCursorWord -auto-resize -direction=botright grep<CR>
  nnoremap <silent> <a-s-p> :Denite -auto-resize -direction=botright grep<CR>
  nnoremap <silent> <c-a-o> :Denite -auto-resize -direction=botright outline<CR>
  nnoremap <leader>\ :Denite -auto-resize -direction=botright command<CR>

  call denite#custom#alias('source', 'git', 'file/rec')
  call denite#custom#var('git', 'command',
        \['git',
        \ 'ls-files',
        \ '-c'])

  call denite#custom#alias('source', 'git-other', 'file/rec')
  call denite#custom#var('git-other', 'command',
        \['git',
        \ 'ls-files',
        \ '-o',
        \ '--exclude-standard'])

  call denite#custom#alias('source', 'git-submodules', 'file/rec')
  call denite#custom#var('git-submodules', 'command',
        \['sh', '-c',
        \ 'git config --file .gitmodules --get-regexp path | cut -d " " -f2- | xargs git ls-files --recurse-submodules'])

  call denite#custom#var('file/rec', 'command',
        \['ag',
        \'--follow',
        \'--nocolor',
        \'--nogroup',
        \'-g', ''])
"}}}

" UltiSnips ---------------------------------------------------------------{{{
  let g:UltiSnipsExpandTrigger="<NUL>"
  let g:UltiSnipsListSnippets="<NUL>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

  let g:ulti_expand_res = 0 "default value, just set once

"}}}

" Depolete ----------------------------------------------------------------{{{

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

  " lua
  let g:lua_check_syntax = 0
  let g:lua_complete_omni = 1
  let g:lua_complete_dynamic = 0
  let g:lua_define_completion_mappings = 0

  if !exists('g:deoplete#sources')
    let g:deoplete#sources={}
  endif
  let g:deoplete#sources._=['buffer', 'file', 'ultisnips']
  let g:deoplete#sources.python=['buffer', 'file', 'ultisnips', 'LanguageClient']
  let g:deoplete#sources.rust=['ultisnips', 'LanguageClient']
  let g:deoplete#sources.cpp=['ultisnips', 'LanguageClient']
  let g:deoplete#sources.c=['ultisnips', 'LanguageClient']
  let g:deoplete#sources.go=['ultisnips', 'LanguageClient']

  let g:LanguageClient_hasSnippetSupport = 0

  function SetLSPShortcuts()
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

  augroup LSP
    autocmd!
    autocmd FileType cpp,c,go,rust,python call SetLSPShortcuts()
  augroup END

  if !exists('g:deoplete#omni#functions')
    let g:deoplete#omni#functions = {}
  endif
  let g:deoplete#omni#functions.lua = 'xolox#lua#omnifunc'
"}}}

" Theme -------------------------------------------------------------------{{{

  syntax on
  "let g:gruvbox_contrast_dark = "hard"
  set background=dark
  colorscheme jellybeans
  highlight SpecialKey ctermfg=darkgrey guibg=none gui=NONE
"}}}

" IDE ---------------------------------------------------------------------{{{
  nmap <f6> :make<CR>
  nmap <f5> :enew<CR>:call termopen(runprg, {'name': '[execution]'})<CR>
"}}}

" vim-airline -------------------------------------------------------------{{{

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
  let g:airline_theme='jellybeans'

  tmap <esc><esc> <c-\><c-n>
  nmap <a-right> :bnext<CR>
  nmap <a-left> :bprevious<CR>
  tmap <a-right> <C-\><C-n>:bprevious<CR>
  tmap <a-left> <C-\><C-n>:bprevious<CR>
  nmap <a-l> :bnext<CR>
  nmap <a-h> :bprevious<CR>
  tmap <a-l> <C-\><C-n>:bprevious<CR>
  tmap <a-h> <C-\><C-n>:bprevious<CR>
  nmap <leader>c :Bdelete<CR>
  tmap <leader>1  <C-\><C-n><Plug>AirlineSelectTab1
  tmap <leader>2  <C-\><C-n><Plug>AirlineSelectTab2
  tmap <leader>3  <C-\><C-n><Plug>AirlineSelectTab3
  tmap <leader>4  <C-\><C-n><Plug>AirlineSelectTab4
  tmap <leader>5  <C-\><C-n><Plug>AirlineSelectTab5
  tmap <leader>6  <C-\><C-n><Plug>AirlineSelectTab6
  tmap <leader>7  <C-\><C-n><Plug>AirlineSelectTab7
  tmap <leader>8  <C-\><C-n><Plug>AirlineSelectTab8
  tmap <leader>9  <C-\><C-n><Plug>AirlineSelectTab9
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
"}}}

" nerdtree ----------------------------------------------------------------{{{
  nmap <leader>o :TagbarToggle<CR>

  function IsNerdTreeEnabled()
    return exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
  endfunction

  function NERDTreeFindToggle()
    if IsNerdTreeEnabled()
      :NERDTreeClose
    else
      :NERDTreeFind
    endif
  endfunction

  nnoremap <silent> <C-\> :call NERDTreeFindToggle()<CR>

" rust --------------------------------------------------------------------{{{

  set hidden
  let g:neomake_rust_enabled_makers = []
  autocmd BufWritePost *.rs Neomake! cargo
  let g:racer_cmd = $HOME."/.cargo/bin/racer"
  let g:LanguageClient_serverCommands = {
    \ 'rust':   ['rls'],
    \ 'c'   :   [g:plug_home.'/ccls/Release/ccls'],
    \ 'cpp' :   [g:plug_home.'/ccls/Release/ccls'],
    \ 'go'  :   ['bingo'],
    \ 'python': [g:plug_home.'/pyls-vimplug/pyls'],
    \ }
"}}}

" neomake -----------------------------------------------------------------{{{

  autocmd! BufWritePost * Neomake
  let g:neomake_verbose = 0
"}}}

" keyboard short-cuts -----------------------------------------------------{{{

  nmap <leader>t :term<cr>
  nmap <silent> <c-s-up> :call feedkeys( line('.')==1 ? '' : 'ddkP' )<CR>
  nmap <c-s-down> ddp
  nmap <silent> <c-s-k> :call feedkeys( line('.')==1 ? '' : 'ddkP' )<CR>
  nmap <c-s-j> ddp
  nmap <c-s> :w<CR>
  vmap <leader>y "+y
  nmap <F12> :nohl<CR>:call LanguageClient_clearDocumentHighlight()<CR>
"}}}

" extra whitespace --------------------------------------------------------{{{

  :highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
  :au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  :au InsertLeave * match ExtraWhitespace /\s\+$/
  :set listchars=tab:▸\ ,trail:·
  :set list

"}}}

" viewdoc -----------------------------------------------------------------{{{
  let g:no_plugin_maps = 1
  let g:viewdoc_open='edit'
  let g:viewdoc_only=0
  let g:viewdoc_openempty=0
  nmap <leader>D :doc! <cword><CR>
  let g:viewdoc_godoc_cmd='go docf'
"

" plumb -------------------------------------------------------------------{{{

  nmap <leader>p "zyy:call plumb#exec('<c-r>z') <CR>
  vmap <leader>p "zy:call plumb#exec(@z) <CR>
"}}}

" terminal ----------------------------------------------------------------{{{

  " when in built-in terminal open in current vim
  let $EDITOR="nvim_open"
"}}}

" ag ----------------------------------------------------------------------{{{
  set grepprg=ag\ --vimgrep
"}}}

" lvimrc ------------------------------------------------------------------{{{

  let g:localvimrc_persistent=2
"}}}

  let g:LanguageClient_serverCommands = {
    \ 'rust':   ['rls'],
    \ 'c'   :   [g:plug_home.'/ccls/Release/ccls'],
    \ 'cpp' :   [g:plug_home.'/ccls/Release/ccls'],
    \ 'go'  :   ['bingo'],
    \ 'python': [g:plug_home.'/pyls-vimplug/pyls'],
    \ }
" vim: set tabstop=2 shiftwidth=2 expandtab:

