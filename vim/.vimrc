" theme
set termguicolors
syntax on
colorscheme slate
hi Normal guibg=NONE ctermbg=NONE

" cursor change

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

hi StatusLine guibg=#005f5f guifg=#ffffff gui=bold
hi StatusLineNC guibg=#303030 guifg=#888888

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

