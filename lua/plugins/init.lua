return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- format on save
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
  {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 1000,
    config = function()
      local notify = require("notify")

      notify.setup({
        background_colour = "#000000",
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
    end,
  },

  -- LazyGit плагин
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gs", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    dependencies = { "romgrk/fzy-lua-native" },
    config = function()
      local wilder = require('wilder')
      wilder.setup({ modes = { ':', '/', '?' } })

      wilder.set_option('renderer', wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = { ' ', wilder.popupmenu_devicons() },
        right = { ' ', wilder.popupmenu_scrollbar() },
      }))

      wilder.set_option('pipeline', {
        wilder.branch(
          wilder.cmdline_pipeline({
            fuzzy = 1,
            set_pcre2_pattern = 1,
          }),
          wilder.search_pipeline(),
          {
            wilder.check(function(_, x) return x == '' end),
            wilder.history(),
          }
        ),
      })
    end,
  },
}
