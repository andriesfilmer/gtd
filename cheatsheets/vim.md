- [vim (my) Cheatsheet](#vim-my-cheatsheet)
  * [Command mode](#command-mode)
  * [Visual mode](#visual-mode)
  * [Search in file](#search-in-file)
  * [Find in files](#find-in-files)
  * [Replace in file](#replace-in-file)
  * [Replace in files](#replace-in-files)
  * [Registers](#registers)
  * [Completions](#completions)
  * [Folding](#folding)
  * [Windows](#windows)
  * [Macros](#macros)
  * [ctags](#ctags)
  * [Spell](#spell)
  * [Mount Capslock to Esc](#mount-capslock-to-esc)
    + [Numbering lines in a file](#numbering-lines-in-a-file)
    + [Tabs and Spaces](#tabs-and-spaces)
  * [Printing](#printing)
  * [Plugins](#plugins)
  * [Links](#links)

<!-- END TOC -->

# vim (my) Cheatsheet

* [Moving around](http://vim.wikia.com/wiki/Moving_around)

## Command mode

    dd                                 " cut and copy current line
    :19y                               " copy line 19
    :19t33                             " copy line 19 to 33
    u                                  " undo
    Ctrl+r                             " redo
    .                                  " repeat
    *                                  " Goto next word under cursor
    #                                  " Goto previeus word under cursor
    ctr]                               " Goto tag in buffers (ctr-o) togo back.
    m{a-z}                             " Mark position as {a-z} E.g. ma
    '{a-z}                             " Move to mark position {a-z} E.g. 'a
    ''                                 " Move to mark previous position
    cit                                " Change In-to tag
    ci"                                " Change In-to "
    ci)                                " Change In-to )
    ci]                                " Change In-to ]
    :ls                                " Show buffers
    :vertical sb 3                     " Open buffer 3 in split window

## Visual mode

    vip                                " Visual select column
    vat                                " Select outer tag block
    vit                                " Select inner tag block.
    Shift+v                            " Select lines
    Ctrl+v                             " Select column
    ~                                  " Switch case on selected, lower to upper or upper to lower case
    =                                  " Auto ident
    Shift+>                            " Indent section
    zf                                 " Folding, nice in combination with `vat`

## Search in file

Press `/` to start a search.

    /regexp                            " Searches forwards for regexp, ? reverses direction
    n                                  " Repeat search, N reverses direction
    *                                  " Searches forward for word under cursor, # reverses direction

## Find in files

    :vim foo **/*.js | cw              " Search for foo in every JavaScript file in the parent directories recursively.
    :vim foo app/**/*.rb | cw          " Search for foo in every Ruby file in the app directory recursively.

## Replace in file

Press `:`

    :%s/foo/bar/gc                     " Search for 1 and replace with 2, options are: g = global (entire file), c = confirm change
    :%s/\s\+$//                        " Delete all trailing whitespace (at the end of each line) with
    :%s/^\s\+//                        " More rarely, you might want to delete whitespace at the beginning of each line
    :g/sometext/d                      " Delete all lines containing `sometext`
    :g/^\(#\|$\)/d                     " Remove comment lines
    :g/^$/d                            " Delete all empty lines:
    :'<,'>s/foo/bar/g                  " Replace words in  visual mode.
    :%s/<Ctrl-V><Ctrl-M>/Ctrl-M/g      "Change file format Windows to Unix, where <Ctrl-V><Ctrl-M> means type Ctrl+V then Ctrl+M.

## Replace in files

    :arg **/*.js                           " Set all *.js files and below current directory in :arg
    :argdo %s/pattern/replace/gce | update " Confirm updates in recursieve files

## Registers

    :reg                               " See registers
    "ay                                " Yank selected text in register 'a'.
    "ap                                " Past selected text form register 'a'.
    ctrl-ra                            " Past register a (in insert mode)
    ctrl-^                             " Go to last edit file #"

## Completions

    Ctrl-p                             " Completion for al (back) words from this file, other open files and registers.
    Ctrl-n                             " Completion for al (forward) words from this file, other open files and registers.
    Ctrl-x + Ctr-]                     " Completion for tags
    Ctrl-x + Ctr-f                     " Completion for filenames
    Ctrl-x + Ctr-l                     " Completion for lines
    Ctrl-x + Ctr-o                     " Completion for methods (omnifunction must be on)

## Folding

    zi                                 " Switch folding on or off
    za                                 " Toggle current fold open/closed
    zR                                 " Open all folds
    zM                                 " Close all folds

## Windows

    :sp                                " split window horizontal
    :vs                                " split window vertical
    :vertical resize 50                " To resize the current window to exactly 50 characters wide.
    :set scrollbind cursorbind cursorline  " compare two files on same line with scroll in :vs

## Macros

    qq                                 " Starts recording the macro 'q'
    q                                  " Stops recording the macro
    <num>@q                            " Repeat the macro <num> number of times

## ctags

    ctags -R *
    ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)

Now you can jump from file to file:

    ctrl-]                             " Jump to class (in other file)
    ctrl-o                             " Jump Out (back)
    ctrl-i                             " Jump In (again)
    ctrl-t                             " Jump back to previous (?)

## Spell

Download
[nl.utf-8.spl](ftp://ftp.vim.org/pub/vim/runtime/spell/nl.utf-8.spl),
[nl.utf-8.spl](ftp://ftp.vim.org/pub/vim/runtime/spell/nl.utf-8.sug),
[nl.utf-8.spl](ftp://ftp.vim.org/pub/vim/runtime/spell/nl.latin1.spl),
[nl.utf-8.spl](ftp://ftp.vim.org/pub/vim/runtime/spell/nl.latin1.sug) into `.vim/spell/`

    :setlocal spell spelllang=en_us
    :setlocal spell spelllang=nl_nl
    :set spell
    :set nospell

## Mount Capslock to Esc

I like to mount the CapsLock to the Esc key. Install `dconf-tools` and open `dconf-editor`.

Navigate to `org >> gnome >> desktop >> input-sources`

Put your options under xkb-options as a list. Ex: ['caps:escape','..other..']

Or just run `setxkbmap -option caps:escape` but this vanishes after reboot.

### Numbering lines in a file
A neat filtering trick using the 'nl' for adding linenumbers.

    :%! nl -ba                           " Whole file
    :'<,'>! nl -ba                       " Visual selection

### Tabs and Spaces

1 - Convert tabs to spaces
    :set expandtab
    :%retab!

2 - Convert spaces to tabs
    :set noexpandtab
    :%retab!

## Printing

    :set printfont=Courier\ 10           " Font size 10
    :set printfont=courier:h10           " Height 10
    :set printoptions=left:2pc           " Left marigin (default 10pc)
    :ha(rdcopy)

## Plugins

* [NerdTree](https://github.com/scrooloose/nerdtree) - NERDTreeToggle -> F8 mapping
* [TagBar](https://github.com/majutsushi/tagbar) -  TagbarOpenAutoClose -> F9 mapping
* [Vim-rails](https://github.com/tpope/vim-rails) - Easy navigation of the Rails directory structure -> `gf`
* [Vim-signify](https://github.com/mhinz/vim-signify) - Indicate added, modified and removed lines (Tip: SignifyHunkDiff)
* [gnupg.vim](http://www.vim.org/scripts/script.php?script_id=661) - Add in  .bashrc `export GPG_TTY=tty`
* [Ctrlp](https://github.com/kien/ctrlp.vim) - Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
* [Markdown](https://github.com/JamshedVesuna/vim-markdown-preview) - markdown-preview -> Ctrl-p
* [Emmet tutorial](https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL)

Packages added in the `.vim/pack/bundle/opt` folder may be loaded using

    :packadd packagename

## Links

* [Vimcasts](http://vimcasts.org/)
* [Let Vim Do the Typing - Video](https://www.youtube.com/watch?v=3TX3kV3TICU)
