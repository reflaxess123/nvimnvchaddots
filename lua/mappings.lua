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

-- Keymaps for splits (дополнительные к NvChad)
map("n", "<F4>", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<F5>", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sv", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>sh", ":vsplit<CR>", { desc = "Split window vertically" })

-- Navigation between splits
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize splits
map("n", "<C-S-Up>", "<C-w>+", { desc = "Increase window height" })
map("n", "<C-S-Down>", "<C-w>-", { desc = "Decrease window height" })
map("n", "<C-S-Left>", "<C-w>>", { desc = "Increase window width" })
map("n", "<C-S-Right>", "<C-w><", { desc = "Decrease window width" })

-- Альтернативные кеймапы для ресайза (если Ctrl+Shift не работает)
map("n", "<leader>=", "<C-w>+", { desc = "Increase window height" })
map("n", "<leader>-", "<C-w>-", { desc = "Decrease window height" })
map("n", "<leader>.", "<C-w>>", { desc = "Increase window width" })
map("n", "<leader>,", "<C-w><", { desc = "Decrease window width" })

-- Переключение между буферами
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<F6>", ":enew<CR>", { desc = "New buffer" })

-- Функция для правильного закрытия буферов
local function close_buffer()
  local current_buf = vim.api.nvim_get_current_buf()

  -- Проверяем, что буфер существует и загружен
  if not vim.api.nvim_buf_is_valid(current_buf) or not vim.api.nvim_buf_is_loaded(current_buf) then
    return
  end

  -- Проверяем, что это не специальный буфер
  local buftype = vim.bo[current_buf].buftype
  local filetype = vim.bo[current_buf].filetype
  local buf_name = vim.api.nvim_buf_get_name(current_buf)

  if buftype ~= "" or filetype == "NvimTree" or string.match(buf_name or "", "NvimTree") then
    vim.notify("Cannot close special buffer")
    return
  end

  -- Считаем только обычные буферы (не nvim-tree и другие специальные)
  local buf_count = 0
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and
        vim.api.nvim_buf_is_loaded(buf) and
        vim.bo[buf].buflisted and
        vim.bo[buf].buftype == "" and
        vim.bo[buf].filetype ~= "NvimTree" then
      local check_name = vim.api.nvim_buf_get_name(buf)
      if not string.match(check_name or "", "NvimTree") then
        buf_count = buf_count + 1
        table.insert(buffers, buf)
      end
    end
  end

  if buf_count > 1 then
    -- Найти следующий буфер для переключения
    for i, buf in ipairs(buffers) do
      if buf == current_buf then
        local next_buf = buffers[i + 1] or buffers[i - 1] or buffers[1]
        if next_buf and next_buf ~= current_buf then
          vim.api.nvim_set_current_buf(next_buf)
          break
        end
      end
    end
    -- Безопасно удаляем буфер
    pcall(vim.api.nvim_buf_delete, current_buf, { force = false })
  else
    vim.cmd("enew")
    pcall(vim.api.nvim_buf_delete, current_buf, { force = false })
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


-- История уведомлений
map("n", "<leader>nh", function()
  -- Пробуем разные способы
  local ok1, _ = pcall(vim.cmd, "Notifications")
  if not ok1 then
    local ok2, _ = pcall(function() require("notify").history() end)
    if not ok2 then
      -- Через Telescope если есть
      local ok3, _ = pcall(vim.cmd, "Telescope notify")
      if not ok3 then
        vim.notify("История уведомлений недоступна", "warn")
      end
    end
  end
end, { desc = "Show notification history" })

-- Терминал кеймапы
map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-q>", "<C-\\><C-n>:q<CR>", { desc = "Close terminal" })
map("t", "<Esc>", "<C-\\><C-n>:q<CR>", { desc = "Close floating terminal" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window from terminal" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to down window from terminal" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to up window from terminal" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window from terminal" })

-- Управление терминалами через Telescope
map("n", "<leader>td", function()
  vim.cmd("Telescope terms")
  -- В окне Telescope используйте Ctrl+X чтобы закрыть терминал
end, { desc = "Delete/manage terminals" })

-- Быстрый выход на двойной Esc
map("n", "<Esc><Esc>", ":qa!<CR>", { desc = "Quick force exit Neovim" })

-- Исправление проблемы с пустыми буферами
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()

    -- Проверяем, что текущий буфер валидный
    if not vim.api.nvim_buf_is_valid(current_buf) then
      return
    end

    local buf_name = vim.api.nvim_buf_get_name(current_buf)
    local buftype = vim.bo[current_buf].buftype
    local filetype = vim.bo[current_buf].filetype

    -- Игнорируем специальные буферы
    if buftype ~= "" or filetype == "NvimTree" or string.match(buf_name or "", "NvimTree") then
      return
    end

    if buf_name ~= "" then
      -- Найти и удалить пустые безымянные буферы
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current_buf and
            vim.api.nvim_buf_is_valid(buf) and
            vim.api.nvim_buf_is_loaded(buf) then
          local check_name = vim.api.nvim_buf_get_name(buf)
          local check_buftype = vim.bo[buf].buftype
          local check_filetype = vim.bo[buf].filetype

          -- Проверяем, что это обычный пустой буфер
          if check_name == "" and
              check_buftype == "" and
              check_filetype ~= "NvimTree" and
              not vim.bo[buf].modified and
              vim.api.nvim_buf_line_count(buf) <= 1 then
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            if #lines <= 1 and (lines[1] == nil or lines[1] == "") then
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
          end
        end
      end
    end
  end,
})
