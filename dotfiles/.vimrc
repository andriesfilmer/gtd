filetype plugin indent on
syntax on

set colorcolumn=80,120                             " Show vertical bar to indicate 80/120 chars
set encoding=utf-8
set expandtab                                      " On pressing tab, insert spaces no tabs (»·)
set foldmethod=syntax                              " Folds are defined by syntax highlighting
set history=1000                                   " The command-lines that you enter, default 50
set hlsearch                                       " highlight all search matches
set ignorecase smartcase                           " Search: ignore case, unless uppercase chars given
set incsearch                                      " Set increase search, Search while you type
set laststatus=2                                   " first, enable status line always
set list listchars=tab:»·,trail:·                  " Make tabs visual: ».......
set nocompatible                                   " don't need to be compatible with old vim
set nofoldenable                                   " Dont fold by default
set nowrap                                         " Default is wrap
set number                                         " Set line numbers, default commented out
set omnifunc=syntaxcomplete#Complete               " Omni completion provides smart autocompletion for programs
set paste                                          " Distinguish between typed text and pasted text in terminal
set shiftround                                     " Indentation: When at 3 spaces, >> takes to 4, not 5
set shiftwidth=2                                   " when indenting with '>', use 2 spaces width
set showmatch                                      " show bracket matches
set tabstop=4                                      " tab with 4 spaces width
set timeoutlen=300 ttimeoutlen=300                 " Prefent delay after pressing ESC (switching to normal mode)
set updatetime=1000                                " vim-gitgutter, vim-signify, default value is 4000
set wildmenu                                       " Show tab completions in statusline
set wildmode=list:full                             " Command mode tab completion - complete upto ambiguity

" Mostly not needed
"set belloff=all                                    " Disable beep
set cursorline                                     " highlight current line. Is slower :-(
"set cursorcolumn                                   " highlight column line. Is slower :-(
"set directory=~/.tmp                               " Don't clutter my dirs with swp/tmp files
"set backupdir=~/.vim/tmp                           " Don't clutter my dirs with swp/tmp files
"set wrap                                           " Wrapping on, default commented out


"------------------------------------------------------------------------------
" Colors
"------------------------------------------------------------------------------
" https://github.com/NLKNguyen/papercolor-theme/
if !empty(glob("~/.vim/colors/PaperColor.vim"))
  colorscheme PaperColor
  set background=dark
endif

highlight ExtraWhitespace ctermbg=1               " Highlight trailing spaces in annoying red
highlight nonascii ctermbg=2
highlight ColorColumn ctermbg=236


"------------------------------------------------------------------------------
" Mappings -> List maps :nmap, :vmap
"------------------------------------------------------------------------------
let mapleader = "\<Space>"                        " Set leader to space

nnoremap <CR> :noh<CR><CR>                        " unsets last search pattern hitting return
nmap <C-n> :Lex 30<CR>                            " Open netrw Directory Listing

nmap <C-Up> :wincmd k<CR>                         " Arrow keys, Alt+leftarrow will go one window left, etc.
nmap <C-Down> :wincmd j<CR>
nmap <C-Left> :wincmd h<CR>
nmap <C-Right> :wincmd l<CR>

nmap <A-up> :resize -2<CR>                        " Resize windows with arrows
nmap <A-down> :resize +2<CR>
nmap <A-left> :vertical resize -2<CR>
nmap <A-right> :vertical resize +2<CR>

nnoremap <tab> :bnext<CR>                         " Cycle trough buffers
nnoremap <S-tab> :bprevious<CR>

nmap <leader>n :set nu!<CR>                        " Toggle linenumbers
nmap <leader>r :set rnu!<CR>                      " Toggle relativenumbers
nmap <leader>h :nohlsearch<CR>                    " Set hlsearch off

"comment (cc) and  uncomment (cu) code
noremap   <silent> cc      :s,^\(\s*\)[^#]\@=,\1# ,e<CR>:nohls<CR>zvj
noremap   <silent> cu      :s,^\(\s*\)# \s\@!,\1,e<CR>:nohls<CR>zvj

nmap <leader><F3> :e $MYVIMRC<CR>
nmap <leader><F4> :e ~/gtd/cheatsheets/vim.md<CR>

nmap <C-F9> :set background=light<CR>
nmap <C-F10> :set background=dark<CR>

"------------------------------------------------------------------------------
" Statusbar
"-------------------------------------------------- ---------------------------
hi statusline                  ctermfg=gray ctermbg=black
au InsertLeave * hi statusline ctermfg=gray ctermbg=black
au InsertEnter * hi statusline ctermfg=red  ctermbg=black

" Formats the statusline
set statusline=%F                                 " file name
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
" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

match ExtraWhitespace /\s\+$/                      " Show white space, see colors for more info
autocmd BufWritePre * %s/\s\+$//e                  " Removing trailing whitespace on write
syntax match nonascii "[^\x00-\x7F]"               " Display non ascii chars


"------------------------------------------------------------------------------
" Exuberant-ctags`
"------------------------------------------------------------------------------
" First install `sudo apt install exuberant-ctags`
" Run ctags only if project (.git) exists
if !empty(glob(".git"))
  au BufWritePost *.erb,*.rb silent! !eval 'ctags -R --languages=ruby --exclude=.git -o newtags; mv newt gs tags;' &
  "au BufWritePost *.js silent! !eval 'ctags -R --languages=javascript --exclude=.git -o newtags; mv newtags tags;' &
  " First fetch `wget https://github.com/andriesfilmer/gtd/tree/master/.vim/.ctags` for typescript!
  "au BufWritePost *.ts silent! !eval 'ctags -R --languages=typescript --exclude=.git -o newtags; mv newtags tags;' &
endif

