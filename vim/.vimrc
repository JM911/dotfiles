" theme
set termguicolors
syntax on
colorscheme slate
hi Normal guibg=NONE ctermbg=NONE

" cursor change - not working solid (only blinking)
" 0 = Blinking Block
" 1/2 = Blinking/Solid Block
" 3/4 = Blinking/Solid underline
" 5/6 = Blinking/Solid Bar
let &t_SI = "\x1b[6 q"
let &t_SR = "\x1b[4 q"
let &t_EI = "\x1b[2 q"

" line number
set number
set relativenumber

" tab size
set tabstop=2
set shiftwidth=2
set expandtab

" status line
set laststatus=2  " always show
set t_Co=256      " 256 colors

"hi StatusLine guibg=#005f5f guifg=#ffffff gui=bold
highlight StatusLine guibg=#005f87 guifg=#ffffff
"hi StatusLineNC guibg=#303030 guifg=#888888
highlight StatusLineNC guibg=#2e2e2e guifg=#888888 " not working

set statusline=
set statusline+=%#StatusLine#
set statusline+=%f          " file name
set statusline+=%m          " show modified [+]
set statusline+=%r          " show readOnly [RO]
set statusline+=%y          " show filetype
set statusline+=%=
set statusline+=%{&fileencoding?&fileencoding:&encoding} " encoding
set statusline+=\ [%l/%L]   " cur line / total line
set statusline+=\ %c        " cur column
set statusline+=\ %p%%      " cur position (%)

