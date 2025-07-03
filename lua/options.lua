require "nvchad.options"

-- add yours here!

local o = vim.o

-- Относительная нумерация строк
o.relativenumber = true
o.number = true

-- Настройки диагностики
vim.diagnostic.config({
  virtual_text = false, -- отключаем inline текст ошибок
  signs = true,         -- оставляем иконки в gutter
  underline = true,     -- подчеркивание ошибок
  update_in_insert = false,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Принудительно отключаем virtual_text после загрузки
vim.schedule(function()
  vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
  })
end)

-- Настройка волнистых подчеркиваний для диагностики
vim.cmd([[
  hi DiagnosticUnderlineError gui=undercurl guisp=Red
  hi DiagnosticUnderlineWarn gui=undercurl guisp=Orange
  hi DiagnosticUnderlineInfo gui=undercurl guisp=Blue
  hi DiagnosticUnderlineHint gui=undercurl guisp=Green
]])


-- o.cursorlineopt ='both' -- to enable cursorline!
