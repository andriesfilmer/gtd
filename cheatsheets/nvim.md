# [Neovim](https://neovim.io/)

Based on Vim. Look at the command [cheatsheet for vim](vim.md).

It looks like there are multiple version of nvim like: kickstart, lazyvim, NvChad, Lunarvim and many more.
But they are only different because of there configuration and plugins. At the moment I like NvChad.

## Nerd Fonts
If you like nice icons in your nvim IDE [Install Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)

After download.

    ./install.sh IBMPlexMon## Neo Vim Plugins

JetBrainsMono Nerd Font ?

    ./install.sh ttf-jetbrains-mono-nerd-3.0.2-1


## [nvchad](https://nvchad.com/docs/quickstart/install)

### Default Plugins

* [NvChad/base46](https://github.com/NvChad/base46) | NvChad theme plugin
* [NvChad/ui](https://github.com/NvChad/ui) | Ui plugin handle: Statusline, Tabufline, NvDash, Term
* [NvChad/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) | Colors on css
* [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | Supports plugins icons
* [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Highly extendable fuzzy finder
* [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Basic functionality such as highlighting
* [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) |  File Explorer For Neovim
* [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | Helps you remember your Neovim keymaps
* [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | Powerful formatter plugin for Neovim
* [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs for added, removed, and changed lines
* [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | Package manager for LSP servers, DAP servers, linters, and formatters
* [neovim/nvim-lspconfig](neovim/nvim-lspconfig) | Installing language servers
* [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | A completion engine
* [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Adds indentation guides to Neovim

### Extra Plugins

* [mbbill/undotree](https://github.com/mbbill/undotree) | Visualizes undo history and browse between different undo branches.

## Config changes

### lua/options

    vim.opt.mouse = ''
    vim.opt.colorcolumn = '80'
    vim.opt.ignorecase = true
    vim.cmd[[ au InsertEnter * highlight St_InsertMode guifg=white guibg=red]] -- More contrast on Insert mode.


### lua/mappings

    map("n", "<leader>b", ":NvimTreeFocus<CR>:NvimTreeCollapse<CR>", { desc = "OpenCollapse tree" })
    map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>")
    map('n', '<leader><F5>', vim.cmd.UndotreeToggle, { desc = "Open Undotree"})

## Plugins notes

### nvim-treesitter

Edit `lua/plugins/init.lua` -> `wnvim-treesitter/nvim-treesitte` -> `opts` -> `ensure_installed` -> `ruby` and run:

    :TSInstall ruby

### Language Server Protocol

Ruby

    gem install solargraph     # A ruby lanuage server
    gem install ruby-lsp       # Less functions then solargraph (2024-07-30)


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

### Undotree

    -- lua/plugins/init.lua
    {
      "mbbill/undotree",
      lazy = false,
    },

### nvim-telescope/telescope.nvim

Scope directories

    :Telescope find_files search_dirs=[".", "/config"]
    :Telescope live_grep search_dirs=["/config"]
    :Telescope diagnostics -- Find errors

## Resources
* [neovim user documentation](https://neovim.io/doc/user/)
* [Nvchad introduction](https://docs.rockylinux.org/books/nvchad/)
* [List of resources](https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources) | Plugins etc.
* [Youtube - How I Setup Neovim To Make It AMAZING in 2024: The Ultimate Guide](https://www.youtube.com/watch?v=6pAG3BHurdM) - Josean Martinez
