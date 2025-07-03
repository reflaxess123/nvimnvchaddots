return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- Mason для управления LSP серверами
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "pyright", "jsonls", "cssls", "html", "yamlls", "dockerls", "eslint", "ruff", "lua_ls" },
      })
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Precognition plugin
  {
    "tris203/precognition.nvim",
    event = "BufEnter",
    config = function()
      require("precognition").setup({
        startVisible = true,
        showBlankVirtLine = true,
        highlightColor = { link = "Comment" },
        hints = {
          Caret = { text = "^", prio = 2 },
          Dollar = { text = "$", prio = 1 },
          MatchingPair = { text = "%", prio = 5 },
          Zero = { text = "0", prio = 1 },
          w = { text = "w", prio = 10 },
          b = { text = "b", prio = 9 },
          e = { text = "e", prio = 8 },
          W = { text = "W", prio = 7 },
          B = { text = "B", prio = 6 },
          E = { text = "E", prio = 5 },
        },
      })
    end,
  },

  -- Hydra plugin
  {
    "nvimtools/hydra.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local Hydra = require("hydra")
      
      -- Window management hydra
      Hydra({
        name = "Windows",
        mode = "n",
        body = "<C-w>",
        heads = {
          { "h", "<C-w>h" },
          { "j", "<C-w>j" },
          { "k", "<C-w>k" },
          { "l", "<C-w>l" },
          { "v", "<C-w>v" },
          { "s", "<C-w>s" },
          { "c", "<C-w>c" },
          { "=", "<C-w>=" },
          { "+", "<C-w>+" },
          { "-", "<C-w>-" },
          { "<", "<C-w><" },
          { ">", "<C-w>>" },
          { "q", nil, { exit = true } },
          { "<Esc>", nil, { exit = true } },
        },
      })
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
