# [Neovim](https://neovim.io/)

# Install

[Download pre-built archive](https://github.com/neovim/neovim/releases)

    mkdir ~/.local/bin
    cd ~/Download/ && gunzip nvim-linux64.tar.gz
    mv nvim-linux64 ~/.local/bin
    cd ~/.config && ln -s ~/gtd/dotfiles/.config/nvim nvim

Then add this to your shell config (~/.bashrc, ~/.zshrc, ...):

    export PATH="$PATH:.local/bin/nvim-linux64/bin"

# Dependencies

    sudo apt install ripgrep

# Neovim branches

Based on Vim. Look at the command [cheatsheet for vim](vim.md).

It looks like there are multiple version of nvim like:
[kickstart](https://github.com/nvim-lua/kickstart.nvim),
[lazyvim](https://www.lazyvim.org/),
[NvChad](https://nvchad.com/) and many more.
But they are only different because of there configuration and plugins.

## Nerd Fonts

If you like nice icons in your nvim IDE [Install Nerd Fonts](https://www.nerdfonts.com/font-downloads)

    wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
    && cd ~/.local/share/fonts \
    && unzip JetBrainsMono.zip \
    && rm JetBrainsMono.zip \
    && fc-cache -fv


## [my nvim](https://github.com/andriesfilmer/gtd/tree/master/dotfiles/.config/nvim)

### My Plugins

* [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) |  File Explorer For Neovim
* [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Basic functionality off current buffer
* [neovim/nvim-lspconfig](neovim/nvim-lspconfig) | Installing language servers
* [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | Package manager for LSP servers, DAP servers, linters, and formatters
* [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Highly extendable fuzzy finder
* [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | A completion engine
* [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | Helps you remember your Neovim keymaps
* [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs for added, removed, and changed lines
* [NeogitOrg/neogit](https://github.com/NeogitOrg/neogit) | A git interface inspired by Magit.
* [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | Powerful formatter from different sources
* [mbbill/undotree](https://github.com/mbbill/undotree) | Visualizes undo history and browse between different undo branches.
* [tpope/vim-dadbod](https://github.com/tpope/vim-dadbod) | Plugin for interacting with databases

## Plugins to try
* [tpope/vim-rails](https://github.com/tpope/vim-rails) | Plugin for editing Ruby on Rails applications (if lsp disabled)
* [ggandor/leap.nvim](https://github.com/ggandor/leap.nvim) | general-purpose motion plugin

## Plugins notes

### nvim-treesitter

    :TSInstall ruby
    :InpectTree

Nice keymap for increment selection to named node.

    <C-space>

### neovim/nvim-lspconfig

    :LspInfo

### williamboman/mason.nvim

    :Mason

### stevearc/conform.nvim

    :ConfirmInfo
    :Format                       -- created user command in confirm.lua
    :FormatEnable                 -- created user command in confirm.lua
    :FormatDisable                -- created user command in confirm.lua

### nvim-telescope/telescope.nvim

Scope your directories

    :Telescope find_files search_dirs=[".", "/config"]
    :Telescope live_grep search_dirs=["./config"]
    :Telescope git_bcommits      -- commits for this buffer
    :Telescope git_commits       -- commits for this repository
    :Telescope diagnostics       -- Find errors

### NeogitOrg/neogit

    :Neogit
    c                          -- commit
    ?                          -- For available options

### tpope/vim-dadbod

Sql plugin. Example connection:

    mysql://root:my_password%3F@localhost/database_name


In combination with `kristijanhusak/vim-dadbod-ui` to save connections and queries for later use.

    :DBUI  " Press ? for help. For example go to the right pane and  save the currently opend file as saved queries with `<Leader>W`

### Language Servers

Ruby

    gem install solargraph     -- A ruby lanuage server
    gem install ruby-lsp       -- Less functions then solargraph (2024-07-30)
    gem install rubocop        -- The Ruby Linter/Formatter in combination with 'stevearc/confirm.nvim'


## Resources
* [neovim user documentation](https://neovim.io/doc/user/)
* [Nvchad introduction](https://docs.rockylinux.org/books/nvchad/)
* [List of resources](https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources) | Plugins etc.
* [Youtube - How I Setup Neovim To Make It AMAZING in 2024: The Ultimate Guide](https://www.youtube.com/watch?v=6pAG3BHurdM) - Josean Martinez
* [Youtube - Kickstart - Get Started with Neovim](https://www.youtube.com/watch?v=m8C0Cq9Uv9o) - TJ de Vries
* [The Holy Grail of Neovim Git Integrations](https://www.youtube.com/watch?v=K-FKqXj8BAQ)

