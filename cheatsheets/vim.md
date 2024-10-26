# vim (my) Cheatsheet
## Open file
    :e .                               " Browse to a file to open
    :e <tab>                           " With tab you can complete directories and filename.
    :browse oldfiles                   " Scroll to end and pick a file number (must exists in root)

## Normal (command) mode
    dd                                 " cut and copy current line
    :19y                               " copy line 19
    u                                  " undo
    Ctrl+r                             " redo
    .                                  " repeat last writes
    *                                  " Goto next word under cursor
    #                                  " Goto previeus word under cursor
    %                                  " Commands such as %, [(, [{, ][, and [] navigation between brackets.

    cit                                " Change In-to tag
    ci"                                " Change In-to "
    ci)                                " Change In-to )
    ci]                                " Change In-to ]

## Visual mode
    vip                                " Select inner paragraph
    vap                                " Select outer paragraph
    vit                                " Select inner tag block, :can combinde with "]} etc.
    vat                                " Select outer tag block, can combine with "]} etc.

    Shift+v                            " Select lines
    Ctrl+v                             " Select column
    :'<,'>norm A;                      " Append ; to visual block. i.o. Execute Normal mode commands
    :'<,'>sort                         " Sort visual block. Can commbined with `uniq -c` etc.
    zc                                 " Folding, nice in combination with `vat`
    o                                  " In visual mode jump to other side of visual selection, nice to narrow your selection
    ~                                  " Switch case on selected, lower to upper or upper to lower case
    =                                  " Auto ident

## Buffers
    :ls                                " Show buffers, alias :buffers
    :b{0-9}                            " Open buffer {0-9}. Find number with :ls
    :vertical sb 3                     " Open buffer 3 in split window
    :bd                                " Close buffer, alias :bdelete
    :%bd|e#                            " Close all buffers (%db) except current buffer (e#)

## Windows
    :sp                                " split window horizontal
    :vs                                " split window vertical
    :set scb crb cul                   " scrollbind, cursorbind, cursorline to compare two files on same line with scroll in :vs
    :only                              " Keep only the current window

## Moving around
    ctrl-^                             " Jump between last edit file line"
    ctrl-o                             " Press twice and go to back last edit file and line(s)"
    ctrl-i                             " jump to newer position
    ctr]                               " goto tag in buffers (ctr-o) to go back.
    :ju                                " show list of postions you :jumps, `5 ctrl-o` to jump to jump nr 5

## Marks
    :marks                             " Show list of marks
    m{a-z}                             " Mark position as {a-z} E.g. ma
    '{a-z}                             " Move to mark position {a-z} E.g. 'a
    ''                                 " Move to mark previous position

## Registers
    :reg                               " See registers
    "ay                                " Yank selected text in register 'a'
    "ap                                " Past selected text from register 'a'
    ctrl-r a                           " Past register a (in insert mode)

## Completions (insert mode)
    Ctrl-p                             " Completion for all (back) words from this file, other open files and registers.
    Ctrl-n                             " Completion for all (forward) words from this file, other open files and registers.
    Ctrl-x + Ctr-]                     " Completion for tags
    Ctrl-x + Ctr-f                     " Completion for filenames
    Ctrl-x + Ctr-l                     " Completion for lines
    Ctrl-x + Ctr-o                     " Completion for methods with omnifunction (set omnifunc)

## Search in file
    /regexp                            " Searches forwards for regexp, ? reverses direction
    n                                  " Repeat search, N reverses direction
    *                                  " Searches forward for word under cursor, # reverses direction

## Replace in file
    :%s/foo/bar/gc                     " Search for 1 and replace with 2, options are: g = global (entire file), c = confirm change
    :%s/\s\+$//                        " Delete all trailing whitespace (at the end of each line) with
    :%s/^\s\+//                        " More rarely, you might want to delete whitespace at the beginning of each line
    :g/^\(#\|$\)/d                     " Remove comment lines
    :g/^$/d                            " Delete all empty lines:
    :'<,'>s/foo/bar/g                  " Replace words in  visual mode.
    :%s/<Ctrl-V><Ctrl-M>/Ctrl-M/g      "Change file format Windows to Unix, where <Ctrl-V><Ctrl-M> means type Ctrl+V then Ctrl+M.

## Find in files
    :vim foo **/*.js | cw              " Search for foo in every JavaScript file in the parent directories recursively.
    :vim foo app/**/*.rb | cw          " Search for foo in every Ruby file in the app directory recursively.
    /[^\x00-\x7F]                      " Find non-ascii characters

## Replace in files

`cdo` is generally a good option when you're working with files that are part of a grep or search result.
It applies the command to each file in the quickfix list. You can see and skip the changes.

    :vimgrep /search_pattern/ **/*.rb
    :cdo %s/old_string/new_string/gc

`argsdo` works on all files in the argument list. Use it if you've loaded files into your argument list and want to apply a command to each of them.

    :args **/*.rb
    :argsdo %s/old_string/new_string/gc | update

## Moving Viewport
    zz                                 " Set viewport in center
    zt                                 " Set viewport in top
    zb                                 " Set viewport in bottom

## Sessions
    :mks                               " Save your session in current dir (default: `Session.vim`)
    vim -S                             " Start with your saved session in current dir
    vim mks! .session-lang.vim         " Save session to `.session.lang.vim` file
    vim -S .session-lang.vim           " Start with your a session
    :source Session.vim                " Load stored session if vim already open.

## Changes
    :changes                           " Show the list of changes
    3g;                                " Go 3 changes back

## Folding
    zc                                 " Fold current selection/syntax
    zo                                 " Open current fold
    zR                                 " Open all folds
    zM                                 " Close all folds

## Indent
    =ap                                " Format and align and ident paragraph
    gg=G                               " Format and align and ident hole file

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

## Videos
* [We don't need a plugin manager](https://www.youtube.com/watch?v=X2_R3uxDN6g)

## Resources
* [Learn Vim](https://learnvim.irian.to/) | Very nice to read, Specially the Vim Grammar page.
* [Vim help files](https://vimhelp.org) | Help in the browser instead of :help
* [Vim quickreferenc](https://vimhelp.org/quickref.txt.html)
* [Vim command index](https://vimhelp.org/index.html)
* [Vimcasts](http://vimcasts.org/) | Sometimes its nice to view how it works.
* [Vim Statusline Generator](https://www.tdaly.co.uk/projects/vim-statusline-generator/)
* [Let Vim Do the Typing - Video](https://www.youtube.com/watch?v=3TX3kV3TICU)

