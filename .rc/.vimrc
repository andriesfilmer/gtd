"To disable a plugin, add it's bundle name to the following list
"let g:pathogen_disabled = ['YouCompleteMe']
execute pathogen#infect()

filetype plugin indent on
syntax on

"set cursorline                                     " highlight current line. Is slower :-)
set encoding=utf-8
set expandtab                                      " On pressing tab, insert 4 spaces
set hlsearch                                       " highlight all search matches
set ignorecase                                     " Set ignore case, Search case insensitive
set incsearch                                      " Set increase search,	Search while you type
set laststatus=2                                   " first, enable status line always
set list                                           " See end of line's
set list listchars=tab:»·,trail:·                  " Make tabs visual: ».......
set number                                         " Set line numbers, default commented out
set nocompatible                                    " don't need to be compatible with old vim
set omnifunc=syntaxcomplete#Complete               " Omni completion provides smart autocompletion for programs
"set paste                                         " Set paste mode, prevent accumulation of tabs and #'s
set scrolloff=2                                    " minimum lines above/below cursor
set showmatch                                      " show bracket matches
set smartcase                                      " pay attention to case when caps are used
set shiftwidth=2                                   " when indenting with '>', use 2 spaces width
set tabstop=4                                      " show existing tab with 4 spaces width
set ts=2                                           " set indent to 2 spaces
set wildmenu                                       " enable bash style tab completion
set wrap                                           " Wrapping on, default commented out

let g:snips_author="Andries Filmer"                " Assign a global variable for snippets


" Mappings
"------------------------------------------------------------------------------
imap ii <esc><CR>                                  " Map ii to Esc to exit insert-mode
nmap <F3> :set hlsearch!<CR>                       " Toggle highlicht search.
map! <F3> <nop>
map <F5> :setlocal spell! spelllang=nl_nl<CR>      " Toggle dutch spelling syntax

" Alt+leftarrow will go one window left, etc.
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

nmap <F9> :TagbarOpenAutoClose<CR>                 " Needs TagBar plugin.
map <C-Right> :tabn<CR><CR>                        " Go to next tab.
map <C-Left> :tabp<CR><CR>                         " Go to previous tab.

cmap w!! w !sudo tee > /dev/null %  " Allow saving of files as sudo when I forgot to start vim using sudo.

" NERDTree options
"------------------------------------------------------------------------------
nmap <F8> :NERDTreeToggle<CR>
nmap <F2> :tabnew<CR>:NERDTree<CR>
map! <F2> <nop>
let NERDTreeShowHidden=1
"autocmd VimEnter * NERDTree "Open NerdTree
"autocmd VimEnter * wincmd p "Focus on window right


" Statusbar
"------------------------------------------------------------------------------
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
  elseif a:mode == 'r'
    hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
  else
    hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

" default the statusline to green when entering Vim
hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

" Formats the statusline
set statusline=%f                                 " file name
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}, " file encoding
set statusline+=%{&ff}]                           " file format
set statusline+=%y                                " filetype
set statusline+=%h                                " help file flag
set statusline+=%m                                " modified flag
set statusline+=%r                                " read only flag
set statusline+=\ %=                              " align left
set statusline+=Line:%l/%L                        " line X of total lines
set statusline+=\ Col:%c                          " current column
set statusline+=\ Buf:%n                          " Buffer number
"set statusline+=\ [%b][0x%B]\                     " ASCII and byte code under cursor
"------------------------------------------------------------------------------

" Mixed
"------------------------------------------------------------------------------
highlight ExtraWhitespace ctermbg=1 guibg=red      " Highlight trailing spaces in annoying red
match ExtraWhitespace /\s\+$/

autocmd Filetype markdown setlocal syntax=OFF       " Bugfix: Prevent Markdown highlighting for underscores
