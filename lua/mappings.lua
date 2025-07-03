require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Копирование/вставка в системный буфер
map({ "n", "v" }, "y", '"+y', { nowait = true })
map({ "n", "v" }, "yy", '"+yy', { nowait = true })
map({ "n", "v" }, "d", '"+d', { nowait = true })
map({ "n", "v" }, "dd", '"+dd', { nowait = true })
map({ "n", "v" }, "p", '"+p', { nowait = true })
map({ "n", "v" }, "P", '"+P', { nowait = true })

-- Навигация по окнам с Ctrl + стрелки
map("n", "<C-Left>", "<C-w>h")
map("n", "<C-Down>", "<C-w>j")
map("n", "<C-Up>", "<C-w>k")
map("n", "<C-Right>", "<C-w>l")

-- Сохранение
map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc>:w<CR>i", { desc = "Save file" })


-- Форматирование вручную
map("n", "<F3>", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format file" })

-- Копирование в системный буфер
local last_time = vim.loop.hrtime()
local speed = 1

local function smart_jump(key)
  local now = vim.loop.hrtime()
  local delta = (now - last_time) / 1e6 -- миллисекунды
  last_time = now

  if delta < 50 then
    speed = math.min(speed + 1, 3)
  else
    speed = 1
  end

  local keys = tostring(speed) .. key
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

-- Бинды для всех 4 стрелок с поддержкой count
map("n", "<Down>", function() smart_jump("j") end)
map("n", "<Up>", function() smart_jump("k") end)
map("n", "<Left>", function() smart_jump("h") end)
map("n", "<Right>", function() smart_jump("l") end)

-- Keymaps for splits
map("n", "<F4>", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<F5>", ":vsplit<CR>", { desc = "Split window vertically" })

-- Navigation between splits
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Переключение между буферами
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<F6>", ":enew<CR>", { desc = "New buffer" })

-- Функция для правильного закрытия буферов
local function close_buffer()
  local buf_count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      buf_count = buf_count + 1
    end
  end

  if buf_count > 1 then
    vim.cmd("bprevious")
    vim.cmd("bdelete #")
  else
    vim.cmd("enew")
    vim.cmd("bdelete #")
  end
end

map("n", "<F7>", close_buffer, { desc = "Close current buffer" })

-- Diagnostic keymaps
map("n", "<F8>", vim.diagnostic.open_float, { desc = "Show diagnostic message", nowait = true })

map("n", "<C-d>", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0) 
  local current_file = vim.api.nvim_buf_get_name(0)
  local diagnostics = vim.diagnostic.get(0, { lnum = cursor_pos[1] - 1 })
  
  if #diagnostics > 0 then
    local diagnostic = diagnostics[1]
    local line_content = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)[1] or ""
    
    local copy_text = string.format("File: %s\nLine %d: %s\nDiagnostic: %s",
      current_file, cursor_pos[1], line_content, diagnostic.message)
    
    vim.fn.setreg('+', copy_text)
    vim.notify("Diagnostic info copied to clipboard")
  else
    vim.notify("No diagnostics at cursor position")
  end
end, { desc = "Copy diagnostic info to clipboard" })

-- Быстрый выход на двойной Esc
map("n", "<Esc><Esc>", ":qa!<CR>", { desc = "Quick force exit Neovim" })

-- Исправление проблемы с пустыми буферами
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    -- Если это не первый буфер и есть пустой безымянный буфер
    local current_buf = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(current_buf)
    
    if buf_name ~= "" then
      -- Найти и удалить пустые безымянные буферы
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current_buf and
           vim.api.nvim_buf_is_loaded(buf) and 
           vim.api.nvim_buf_get_name(buf) == "" and
           not vim.api.nvim_buf_get_option(buf, "modified") and
           vim.api.nvim_buf_line_count(buf) <= 1 then
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          if #lines <= 1 and (lines[1] == nil or lines[1] == "") then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end
    end
  end,
})
