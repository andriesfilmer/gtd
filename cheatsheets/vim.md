# vim (my) Cheatsheet
## Open file
    :e ..                              " With only enter you can browse to a file
    :e <tab>                           " With tab you can complete directories and filename.

## Command mode
    dd                                 " cut and copy current line
    :19y                               " copy line 19
    :19t33                             " copy line 19 to 33
    u                                  " undo
    Ctrl+r                             " redo
    .                                  " repeat last writes
    *                                  " Goto next word under cursor
    #                                  " Goto previeus word under cursor
    ctrl-o                             " Jump to older position
    ctrl-i                             " Jump to newer position
    ctr]                               " Goto tag in buffers (ctr-o) to go back.
    %                                  " Commands such as %, [(, [{, ][, and [] navigation between brackets.
    cit                                " Change In-to tag
    ci"                                " Change In-to "
    ci)                                " Change In-to )
    ci]                                " Change In-to ]

## Visual mode
    Shift+v                            " Select lines
    Ctrl+v                             " Select column
    vip                                " Visual select column
    vat                                " Select outer tag block
    vit                                " Select inner tag block.
    o                                  " In visual mode jump to other side of visual selection, with capital O jump visual block
    ~                                  " Switch case on selected, lower to upper or upper to lower case
    =                                  " Auto ident
    zf                                 " Folding, nice in combination with `vat`

## Buffers
    :ls                                " Show buffers, alias :buffers
    :b{0-9}                            " Open buffer {0-9}. Find number with :ls
    :bd                                " Close buffer, alias :bdeletejj
    :vertical sb 3                     " Open buffer 3 in split window

## Moving around
    :marks                             " Show list of marks
    m{a-z}                             " Mark position as {a-z} E.g. ma
    '{a-z}                             " Move to mark position {a-z} E.g. 'a
    ''                                 " Move to mark previous position
    :ju                                " Show list of postions you jumpeds, alias for :jumps
    ctrl-^                             " Jump between last edit file line"
    ctrl-o                             " Press twice and go to back last edit file and line(s)"

## Windows
    :sp                                " split window horizontal
    :vs                                " split window vertical
    :vertical resize 50                " To resize the current window to exactly 50 characters wide.
    :set scrollbind cursorbind cursorline  " compare two files on same line with scroll in :vs
    :h ctrl-w                          " options to resize windows

## Registers
    :reg                               " See registers
    "ay                                " Yank selected text in register 'a'
    "ap                                " Past selected text form register 'a'
    ctrl-ra                            " Past register a (in insert mode)

## Completions (insert mode)
    Ctrl-p                             " Completion for all (back) words from this file, other open files and registers.
    Ctrl-n                             " Completion for all (forward) words from this file, other open files and registers.
    Ctrl-x + Ctr-]                     " Completion for tags
    Ctrl-x + Ctr-f                     " Completion for filenames
    Ctrl-x + Ctr-l                     " Completion for lines
    Ctrl-x + Ctr-o                     " Completion for methods (omnifunction must be on)

## Search in file
    /regexp                            " Searches forwards for regexp, ? reverses direction
    n                                  " Repeat search, N reverses direction
    *                                  " Searches forward for word under cursor, # reverses direction

## Find in files
    :vim foo **/*.js | cw              " Search for foo in every JavaScript file in the parent directories recursively.
    :vim foo app/**/*.rb | cw          " Search for foo in every Ruby file in the app directory recursively.
    /[^\x00-\x7F]                      " Find non-ascii characters

## Replace in file
    :%s/foo/bar/gc                     " Search for 1 and replace with 2, options are: g = global (entire file), c = confirm change
    :%s/\s\+$//                        " Delete all trailing whitespace (at the end of each line) with
    :%s/^\s\+//                        " More rarely, you might want to delete whitespace at the beginning of each line
    :g/^\(#\|$\)/d                     " Remove comment lines
    :g/^$/d                            " Delete all empty lines:
    :'<,'>s/foo/bar/g                  " Replace words in  visual mode.
    :%s/<Ctrl-V><Ctrl-M>/Ctrl-M/g      "Change file format Windows to Unix, where <Ctrl-V><Ctrl-M> means type Ctrl+V then Ctrl+M.

## Replace in files
Option 1

    :arg **/*.js                           " Set all *.js files and below current directory in :arg
    :argdo %s/pattern/replace/gce | update " Confirm updates in recursieve files

Option 2

    :vimgrep /pattern/ `find . -type f`" Set all files in quickfix list. Use `copen` to see the matches.
    :cdo %s/pattern/replace/gc         " Change all matches with a confirm.

## Moving Viewport
    zz                                 " Set viewport in center
    zt                                 " Set viewport in top
    zb                                 " Set viewport in bottom

## Sessions

    :mks                               " Save your session in current dir (default: `session.vim`)
    vim -S                             " Start with your saved session in current dir
    vim mks! .session-lang.vim         " Save session to `.session.lang.vim` file
    vim -S .session-lang.vim           " Start with your a session

## Changes
    :changes                           " Show the list of changes
    3g;                                " Go 3 changes back

## Folding
    zc                                 " Fold current selection/syntax
    zo                                 " Open current fold
    zR                                 " Open all folds
    zM                                 " Close all folds

## Indent
    =ap                                " Align and ident paragraph
    gg=G                               " Align and ident hole file

## Macros

    qq                                 " Starts recording the macro 'q'
    q                                  " Stops recording the macro
    <num>@q                            " Repeat the macro <num> number of times

To save a macro: Use `qq` as normal, with the `qp` command you can paste the register into `.vimrc`.

    let @q = 'macro contents' "Be careful of quotes, though. They would have to be escaped properly.

Now you can use this macro in normal mode: @q

## ctags

    ctags -R *
    ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)

Now you can jump from file to file:

    ctrl-]                             " Jump to class (in other file)
    ctrl-o                             " Jump Out (back)
    ctrl-i                             " Jump In (again)
    ctrl-t                             " Jump back to previous (?)

## Spell

    z=                                 " When on word show spelling.

Download
[nl.utf-8.spl](ftp://ftp.vim.org/pub/vim/runtime/spell/nl.utf-8.spl),
[nl.utf-8.spl](ftp://ftp.vim.org/pub/vim/runtime/spell/nl.utf-8.sug),
[nl.utf-8.spl](ftp://ftp.vim.org/pub/vim/runtime/spell/nl.latin1.spl),
[nl.utf-8.spl](ftp://ftp.vim.org/pub/vim/runtime/spell/nl.latin1.sug) into `.vim/spell/`

    :setlocal spell spelllang=en_us
    :setlocal spell spelllang=nl_nl
    :set spell
    :set nospell

## Numbering lines in a file
A neat filtering trick using the 'nl' for adding linenumbers.

    :%! nl -ba                           " Whole file
    :'<,'>! nl -ba                       " Visual selection

## Tabs and Spaces

1 - Convert tabs to spaces
    :set expandtab                       " On pressing tab, insert spaces no tabs. (Already in my .vimrc)
    :%retab!

2 - Convert spaces to tabs
    :set noexpandtab
    :%retab!

## Printing
    :set printfont=Courier\ 10           " Font size 10
    :set printfont=courier:h10           " Height 10
    :set printoptions=left:2pc           " Left marigin (default 10pc)
    :ha(rdcopy)

## Colorscheme
    set colorscheme [tab]
    set background=light

## Plugins
* [NerdTree](https://github.com/scrooloose/nerdtree) - NERDTreeToggle -> F8 mapping
* [TagBar](https://github.com/majutsushi/tagbar) -  TagbarOpenAutoClose -> F9 mapping
* [Vim-rails](https://github.com/tpope/vim-rails) - Easy navigation of the Rails directory structure -> `gf`
* [Vim-signify](https://github.com/mhinz/vim-signify) - Indicate added, modified and removed lines (Tip: SignifyHunkDiff)
* [vim-searchindex](https://github.com/google/vim-searchindex) - This simple plugin shows how many times a search pattern occurs in the current buffer.
* [gnupg.vim](http://www.vim.org/scripts/script.php?script_id=661) - Add in  .bashrc `export GPG_TTY=tty`
* [Ctrlp](https://github.com/kien/ctrlp.vim) - Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
* [Markdown](https://github.com/JamshedVesuna/vim-markdown-preview) - markdown-preview -> Ctrl-p
* [Emmet tutorial](https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL)
* **vim-addon-mw-utils** is a Vim plugin that provides various utility functions and scripts to enhance your Vim experience. It doesn't provide any specific features on its own but serves as a foundation for other Vim plugins.

Packages added in the `.vim/pack/bundle/opt` folder may be loaded using

    :packadd packagename

## Videos
* [We don't need a plugin manager](https://www.youtube.com/watch?v=X2_R3uxDN6g)

## Resources
* [Vim help files](https://vimhelp.org)
* [Vim quickreferenc](https://vimhelp.org/quickref.txt.html)
* [Vim command index](https://vimhelp.org/index.html)
* [Learn Vim](https://learnvim.irian.to/)
* [Vimcasts](http://vimcasts.org/)
* [Vim Statusline Generator](https://www.tdaly.co.uk/projects/vim-statusline-generator/)
* [Let Vim Do the Typing - Video](https://www.youtube.com/watch?v=3TX3kV3TICU)

