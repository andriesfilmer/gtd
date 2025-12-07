filetype plugin indent on
syntax on

set encoding=utf-8
set expandtab                             " On pressing tab, insert spaces no tabs (»·)
set foldmethod=syntax                     " Folds are defined by syntax highlighting
set history=1000                          " The command-lines that you enter, default 50
set hlsearch                              " highlight all search matches
set hidden                                " Switch between buffers if the buffer is changed. Think twice when using :q!
set smartcase                             " Search: ignore case, unless uppercase chars given
set incsearch                             " Set increase search, Search while you type
set laststatus=2                          " first, enable status line always
set list listchars=tab:»·,trail:·         " Make tabs visual: ».......
set nocompatible                          " don't need to be compatible with old vim
set nofoldenable                          " Dont fold by default
set nowrap                                " Default is wrap
set number " relativenumber               " Set line numbers, optional with relativenumbers
set cursorline                            " highlight current line. Is slower :-(
set omnifunc=syntaxcomplete#Complete      " Omni completion provides smart autocompletion for programs
set shiftround                            " Indentation: When at 3 spaces, >> takes to 4, not 5
set shiftwidth=2                          " when indenting with '>', use 2 spaces width
set showmatch                             " show bracket matches
set tabstop=4                             " tab with 4 spaces width
set updatetime=1000                       " vim-gitgutter, vim-signify, default value is 4000
set wildmenu                              " Show tab completions in statusline
set wildmode=list:full                    " Command mode tab completion - complete upto ambiguity
set path+=$PWD/**                         " Enable `:find` and `:b` without a full path, i.o. `find *_controller.rb` +tab

" Mostly not needed
"set colorcolumn=80,120                    " Show vertical bar to indicate 80/120 chars
"set belloff=all                           " Disable beep
"set cursorcolumn                          " highlight column line. Is slower :-(
"set directory=~/.tmp                      " Don't clutter my dirs with swp/tmp files
"set backupdir=~/.vim/tmp                  " Don't clutter my dirs with swp/tmp files
"set wrap                                  " Wrapping on, default commented out
"set paste                                 " Distinguish between typed text and pasted text in terminal

"------------------------------------------------------------------------------
" Colors
"------------------------------------------------------------------------------
" https://github.com/NLKNguyen/papercolor-theme/
if !empty(glob("~/.vim/colors/PaperColor.vim"))
  colorscheme PaperColor
  set background=dark
endif

highlight ExtraWhitespace ctermbg=1             " Highlight trailing spaces in annoying red
highlight nonascii ctermbg=2
highlight ColorColumn ctermbg=236

"------------------------------------------------------------------------------
" Mappings -> List maps :nmap, :vmap
"------------------------------------------------------------------------------
let mapleader = "\<Space>"                      " Set leader to space

nnoremap <CR> :noh<CR><CR>                      " unsets last search pattern hitting return
nmap <leader>ee :Lex 30<CR>                     " Toggle netrw Directory root directory
nmap <leader>ef :Vex 30<CR>                     " Toggle netrw Directory working directory

nmap <C-Up> :wincmd k<CR>                       " Arrow keys, Alt+leftarrow will go one window left, etc.
nmap <C-Down> :wincmd j<CR>
nmap <C-Left> :wincmd h<CR>
nmap <C-Right> :wincmd l<CR>

nmap <A-up> :resize -2<CR>                      " Resize windows with arrows
nmap <A-down> :resize +2<CR>
nmap <A-left> :vertical resize -2<CR>
nmap <A-right> :vertical resize +2<CR>

" Buffers
nmap <leader>b :buffers<cr>
nmap <tab> :bnext<CR>                           " Next buffer
nmap <S-tab> :bprevious<CR>                     " Previous buffer
nmap <leader>w :bdelete<CR>                     " Delete buffer
nmap <leader>W :%bd\|e#\|bd#<CR>                " Delete buffers except current

" Open buffers
nmap <leader>oh :browse oldfiles<cr>            " History buffers
nmap <silent><leader>od :!xdg-open %&<cr>       " [o]pen buffer in [d]efault application

nmap <leader>n :set nu!<CR>                     " Toggle linenumbers
nmap <leader>r :set rnu!<CR>                    " Toggle relativenumbers

" vim-powered terminal in new tab
map <Leader>T :tab term ++close<cr>
tmap <Leader>T <c-w>:tab term ++close<cr>

" Save and restore session
nmap <leader>ss :mksession!<cr>
nmap <leader>sr :source Session.vim<cr>         "[s]ession [r]estore for cwd

" Vim custom mappings
nmap <leader>vf :e $MYVIMRC<CR>
nmap <leader>vc :e ~/gtd/cheatsheets/vim.md<CR>
nmap <leader>vg :vimgrep /pattern/g app/**/*

nmap <C-F9> :set background=light<CR>
nmap <C-F10> :set background=dark<CR>

nnoremap <F2> :set paste!<CR>

" use wayland copy instead off `apt install vim-gtk`
vmap y y:call system('wl-copy', @")<CR>
vmap d d:call system('wl-copy', @")<CR>

"------------------------------------------------------------------------------
" Some mappings if plugin is available
"------------------------------------------------------------------------------
nmap <leader>gh :SignifyHunkDiff<CR>             " vim-signify

"------------------------------------------------------------------------------
" Search command
"------------------------------------------------------------------------------
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
endif
" The grep! (with !) prevents automatically jumping to the first match.
command! -nargs=1 Search execute 'silent grep! ' . shellescape(<q-args>) . ' .' | vertical botright copen 50 | redraw!
command! -nargs=1 Search execute 'silent grep! ' . shellescape(<q-args>) . ' .' | botright copen | redraw!

"------------------------------------------------------------------------------
" Statusbar
"-------------------------------------------------- ---------------------------
hi statuslinec ctermfg=gray ctermbg=black
au InsertLeave * hi statusline ctermfg=gray ctermbg=black
au InsertEnter * hi statusline ctermfg=LightRed ctermbg=black


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
"set statusline+=\ [%b][0x%B]\                    " ASCII and byte code under cursor


"------------------------------------------------------------------------------
" Mixed
"------------------------------------------------------------------------------
":h restore-cursor last-position-jump
augroup RestoreCursor
  autocmd!
  autocmd BufReadPost *
    \ let line = line("'\"")
    \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
    \      && index(['xxd', 'gitrebase'], &filetype) == -1
    \ |   execute "normal! g`\""
    \ | endif
augroup END

match ExtraWhitespace /\s\+$/                    " Show white space, see colors for more info
autocmd BufWritePre * %s/\s\+$//e                " Removing trailing whitespace on write
syntax match nonascii "[^\x00-\x7F]"             " Display non ascii chars

"highlight link markdownError Normal             " New error pattern without the red underscore highligted
autocmd BufNewFile,BufRead,BufEnter *.md syn match markdownIgnore "\w\@<=\w\@="

"------------------------------------------------------------------------------
" Exuberant-ctags`
"------------------------------------------------------------------------------
" First install `sudo apt install exuberant-ctags`
" Run ctags only if project (.git) exists
if !empty(glob(".git"))
  au BufWritePost *.erb,*.rb silent! !eval 'ctags -R --languages=ruby --exclude=.git -o newtags; mv newtags tags;' &
  au BufWritePost *.js silent! !eval 'ctags -R --languages=javascript --exclude=.git --exclude=*.min.js -o newtags; mv newtags tags;' &
endif
" Or run manually
command! MakeTags !ctags -R .


"------------------------------------------------------------------------------
" Snippets
"------------------------------------------------------------------------------
iabbr consl console.log("TEST: " + );<esc>2hi
iabbr putsi puts "TEST: " #{}"<esc>1hi

