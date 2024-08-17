# [Neovim](https://neovim.io/)

Based on Vim. Look at the command [cheatsheet for vim](vim.md).

It looks like there are multiple version of nvim like: 
[kickstart](https://github.com/nvim-lua/kickstart.nvim),
[lazyvim](https://www.lazyvim.org/),
[NvChad](https://nvchad.com/) and many more.
But they are only different because of there configuration and plugins.

## Nerd Fonts
If you like nice icons in your nvim IDE [Install Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)

After download.

    ./install.sh IBMPlexMon## Neo Vim Plugins

JetBrainsMono Nerd Font ?

    ./install.sh ttf-jetbrains-mono-nerd-3.0.2-1


## [nvchad](https://nvchad.com/docs/quickstart/install)

### Nice Plugins

* [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Highly extendable fuzzy finder
* [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Basic functionality such as highlighting
* [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) |  File Explorer For Neovim
* [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | Powerful formatter from different sources
* [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs for added, removed, and changed lines
* [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | Package manager for LSP servers, DAP servers, linters, and formatters
* [neovim/nvim-lspconfig](neovim/nvim-lspconfig) | Installing language servers
* [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | A completion engine
* [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | Helps you remember your Neovim keymaps
* [mbbill/undotree](https://github.com/mbbill/undotree) | Visualizes undo history and browse between different undo branches.

## Plugins notes

### nvim-treesitter

Edit `lua/plugins/init.lua` -> `wnvim-treesitter/nvim-treesitte` -> `opts` -> `ensure_installed` -> `ruby` and run:

    :TSInstall ruby

### Language Server Protocol

Ruby

    gem install solargraph     # A ruby lanuage server
    gem install ruby-lsp       # Less functions then solargraph (2024-07-30)
    gem install rubocop        # The Ruby Linter/Formatter in combination with 'stevearc/confirm.nvim'


lua/configs/lspconfig.lua

    local servers = { "html", "cssls", "solargraph" }

lua/plugins/init.lua and setup `"neovim/nvim-lspconfig"` and `williamboman/mason.nvim`

Run`:MasonInstallAll`

These examples are available :-)

    :lua vim.lsp.buf.rename()         -- Rename a variable in whole project
    :lua vim.lsp.buf.definition()     -- Jump to defination in project, ctrl-t to go back
    :lua vim.lsp.buf.references()     -- See references
    :lua vim.lsp.buf.formatting()     -- Format buffer
    :lua vim.diagnostic.open_float()  -- Show full message in floating window

* <https://solargraph.org/guides/getting-started>
* <https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruby_lsp>

### nvim-telescope/telescope.nvim

Scope your directories

    :Telescope find_files search_dirs=[".", "/config"]
    :Telescope live_grep search_dirs=["./config"]
    :Telescope diagnostics -- Find errors

## Resources
* [neovim user documentation](https://neovim.io/doc/user/)
* [Nvchad introduction](https://docs.rockylinux.org/books/nvchad/)
* [List of resources](https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources) | Plugins etc.
* [Youtube - How I Setup Neovim To Make It AMAZING in 2024: The Ultimate Guide](https://www.youtube.com/watch?v=6pAG3BHurdM) - Josean Martinez
* [Youtube - Kickstart - Get Started with Neovim](https://www.youtube.com/watch?v=m8C0Cq9Uv9o) - TJ de Vries
