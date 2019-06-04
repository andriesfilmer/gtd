- [vim (my) Cheatsheet](#vim-my-cheatsheet)
  * [Command mode](#command-mode)
  * [Visual mode](#visual-mode)
  * [Search in file](#search-in-file)
  * [Find in files](#find-in-files)
  * [Replace in file](#replace-in-file)
  * [Replace in files](#replace-in-files)
  * [Completions](#completions)
  * [Jumps in file](#jumps-in-file)
  * [Windows](#windows)
  * [Macros](#macros)
  * [ctags](#ctags)
  * [Spell](#spell)
  * [Other](#other)
    + [Numbering lines in a file](#numbering-lines-in-a-file)
    + [Tabs and Spaces](#tabs-and-spaces)
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
    :ls                                " Show buffers
    :vertical sb 3                     " Open buffer 3 in split window
    m{a-z}                             " Mark position as {a-z} E.g. ma
    '{a-z}                             " Move to mark position {a-z} E.g. 'a
    ''                                 " Move to mark previous position
    cit                                " Change In-to tag
    ci"                                " Change In-to "
    ci)                                " Change In-to )
    ci]                                " Change In-to ]
    :364,379t.                         " Copy lines right under your current line

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
    :'<,'>s/foo/bar/g                  " Replace words in  visual mode.
    :%s/<Ctrl-V><Ctrl-M>/Ctrl-M/g      "Change file format Windows to Unix, where <Ctrl-V><Ctrl-M> means type Ctrl+V then Ctrl+M.

## Replace in files

    :arg **/*.js                           " Set all *.js files and below current directory in :arg
    :argdo %s/pattern/replace/gce | update " Confirm updates in recursieve files

## Completions

    Ctrl-p                             " Completion for al words from this file, other open files and registers.
    Ctrl-x + Ctr-]                     " Completion for words from ctags (if installed)
    Ctrl-x + Ctr-f                     " Completion for filenames
    Ctrl-x + Ctr-l                     " Completion for lines
    Ctrl-x + Ctr-o                     " Completion for methods (ominfunction must be on)

## Jumps in file

    Ctrl-i                             " Jump back to previous (dril in)
    Ctrl-o                             " Jump back to previous (dril out)
    Ctrl-t                             " Jump back to previous (?)

## Folding

    zi                                 " Switch folding on or off
    za                                 " Toggle current fold open/closed
    zR                                 " Open all folds
    zM                                 " Close all folds

## Windows

    :sp                                " split window horizontal
    :vsp                               " split window vertical
    :vertical resize 50                " To resize the current window to exactly 30 characters wide.

## Macros

    qq                                 " Starts recording the macro 'q'
    q                                  " Stops recording the macro
    <num>@q                            " Repeat the macro <num> number of times

## ctags

    ctags -R *
    ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)

Now you can jump from file to file:

    ctrl-]                               " Jump to class (in other file)
    ctrl-o                               " Jump Out (back)
    ctrl-i                               " Jump In (again)

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
A neat filtering trick using the 'nl' linux/unix program.

    :%! nl -ba

### Tabs and Spaces

1 - Convert tabs to spaces
    :set expandtab
    :%retab!

2 - Convert spaces to tabs
    :set noexpandtab
    :%retab!

## Plugins

* [Vim-rails](https://github.com/tpope/vim-rails) - Easy navigation of the Rails directory structure. `gf`
* [TagBar](https://github.com/majutsushi/tagbar) - I use F9 mapping in my .vimrc
* [Emmet tutorial](https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL)
* [gnupg.vim](http://www.vim.org/scripts/script.php?script_id=661) - Add in  .bashrc `export GPG_TTY=tty`
* [Closetag](https://github.com/alvan/vim-closetag)
* [Ctrlp](https://github.com/kien/ctrlp.vim) - Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
* [Markdown](https://github.com/JamshedVesuna/vim-markdown-preview)

## Links

* [Vimcasts](http://vimcasts.org/)
* [Let Vim Do the Typing - Video](https://www.youtube.com/watch?v=3TX3kV3TICU)
