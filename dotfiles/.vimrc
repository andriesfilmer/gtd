filetype plugin indent on
syntax on

set nocompatible                                   " don't need to be compatible with old vim
"set belloff=all                                    " Disable beep
"set cursorline                                     " highlight current line. Is slower :-(
"set cursorcolumn                                   " highlight column line. Is slower :-(
"set scrolloff=2                                    " minimum lines above/below cursor
"set clipboard=unnamedplus                          " Copy to system clipboard (Only vim-gtk)
set foldmethod=syntax                              " Folds are defined by syntax highlighting
set encoding=utf-8
set hlsearch                                       " highlight all search matches
set ignorecase                                     " Set ignore case, Search case insensitive
set smartcase                                      " pay attention to case when caps are used
set incsearch                                      " Set increase search, Search while you type
set laststatus=2                                   " first, enable status line always
set list                                           " See end of line's (i.o. see gray dot)
set list listchars=tab:»·,trail:·                  " Make tabs visual: ».......
set number                                         " Set line numbers, default commented out
set omnifunc=syntaxcomplete#Complete               " Omni completion provides smart autocompletion for programs
set paste                                          " Distinguish between typed text and pasted text in terminal
set showmatch                                      " show bracket matches
set expandtab                                      " On pressing tab, insert spaces no tabs (»·)
set shiftwidth=2                                   " when indenting with '>', use 2 spaces width
set tabstop=4                                      " tab with 4 spaces width
set wildmenu                                       " Show tab completions in statusline
set wrap                                           " Wrapping on, default commented out
set updatetime=1000                                " vim-gitgutter, vim-signify, default value is 4000
set timeoutlen=300 ttimeoutlen=300                 " Prefent delay after pressing ESC (switching to normal mode)

" https://github.com/NLKNguyen/papercolor-theme/
if !empty(glob("~/.vim/colors/PaperColor.vim"))
  colorscheme PaperColor
  set background=dark
endif

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Mappings
"------------------------------------------------------------------------------

" Arrow keys, Alt+leftarrow will go one window left, etc.
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

inoremap <c-c> <c-o>:highlight statusline ctermfg=black ctermbg=red guifg=red guibg=black<cr><c-c>

" Statusbar
"------------------------------------------------------------------------------
hi statusline                  ctermfg=gray ctermbg=black
au InsertLeave * hi statusline ctermfg=gray ctermbg=black
au InsertEnter * hi statusline ctermfg=red  ctermbg=black

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

" Exuberant-ctags`
"------------------------------------------------------------------------------
" First install `sudo apt install exuberant-ctags`
" Run ctags only if project (.git) exists
if !empty(glob(".git"))
  au BufWritePost *.erb,*.rb silent! !eval 'ctags -R --languages=ruby --exclude=.git -o newtags; mv newtags tags;' &
  "au BufWritePost *.js silent! !eval 'ctags -R --languages=javascript --exclude=.git -o newtags; mv newtags tags;' &
  " First fetch `wget https://github.com/andriesfilmer/gtd/tree/master/.vim/.ctags` for typescript!
  "au BufWritePost *.ts silent! !eval 'ctags -R --languages=typescript --exclude=.git -o newtags; mv newtags tags;' &
endif


" Mixed
"------------------------------------------------------------------------------
highlight ExtraWhitespace ctermbg=1 guibg=red      " Highlight trailing spaces in annoying red
match ExtraWhitespace /\s\+$/
autocmd BufWritePre * %s/\s\+$//e                  " Removing trailing whitespace on write

syntax match nonascii "[^\x00-\x7F]"               " Display non ascii chars
highlight nonascii guibg=Red ctermbg=2

