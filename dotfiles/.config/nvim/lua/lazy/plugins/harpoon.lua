return {
  "theprimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon"):setup()
  end,
  keys = {
    { "<leader>H", function() require("harpoon"):list():add() end, desc = "[H]arpoon file", },
    { "<leader>h", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "[h]arpoon quick menu", },
    { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon to file 1", },
    { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon to file 2", },
    { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon to file 3", },
    { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon to file 4", },
    { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "Harpoon to file 5", },
  },
}
