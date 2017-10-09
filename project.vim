" Local project configuration for vim
"
"
" Local general configuration {
    set spell
    set list

" }
"
"
" mappings {
"

" }
"
" Color {
    if filereadable(expand("/home/natan/projects/others/nb_repos/my_dot_files/vim/bundle/papercolor-theme/colors/PaperColor.vim"))
        set background=light
        color PaperColor        " Load a colorscheme
        :highlight SpellBad ctermfg=009 ctermbg=011 guifg=#ff0000 guibg=#ffff00
    endif
" }
"
" add spaces on the list characters
" listchars {
"   space is defined with <c-v>183 in insert mode
    set listchars=space:·
" }
"
Bundle 'Rykka/riv.vim.git'

