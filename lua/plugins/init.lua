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


  -- Плагин уведомлений
  {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 1000,
    config = function()
      local notify = require("notify")

      notify.setup({
        background_colour = "NotifyBackground",
        fps = 30,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "default",
        stages = "fade_in_slide_out",
        timeout = 3000,
        top_down = true
      })

      -- Заменяем стандартную функцию notify
      vim.notify = notify

      -- Тестовое уведомление при загрузке
      vim.defer_fn(function()
        vim.notify("nvim-notify загружен!", "info")
      end, 1000)
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
