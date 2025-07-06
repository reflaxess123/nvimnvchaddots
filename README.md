# Neovim Configuration

Персональный конфиг Neovim на базе NvChad с дополнительными плагинами и настройками.

## Базовая архитектура

- **Основа**: NvChad framework
- **Менеджер плагинов**: lazy.nvim
- **LSP**: встроенный nvim-lspconfig с Mason

## Установленные плагины

### Основные инструменты
- **Mason** - менеджер LSP серверов, линтеров и форматеров
- **Mason-lspconfig** - интеграция Mason с lspconfig
- **nvim-lspconfig** - конфигурация Language Server Protocol

### LSP серверы (автоустановка)
- `ts_ls` - TypeScript/JavaScript
- `pyright` - Python
- `jsonls` - JSON
- `cssls` - CSS
- `html` - HTML
- `yamlls` - YAML
- `dockerls` - Docker
- `eslint` - ESLint
- `ruff` - Python linter/formatter
- `lua_ls` - Lua

### Продуктивность
- **conform.nvim** - форматирование кода при сохранении
- **precognition.nvim** - подсказки Vim движений
- **wilder.nvim** - автодополнение командной строки с историей
- **nvim-notify** - красивые уведомления

### Git интеграция
- **lazygit.nvim** - интеграция с LazyGit

### Управление окнами
- **hydra.nvim** - режим управления окнами

### AI помощник
- **claudecode.nvim** - интеграция с Claude Code

## Основные хоткеи

### Общие
- `;` → `:` - вход в командный режим
- `jk` - выход из режима вставки (в insert mode)

### Git
- `<leader>gs` - открыть LazyGit

### Claude Code
- `<leader>ac` - переключить Claude
- `<leader>af` - фокус на Claude
- `<leader>as` - отправить выделенный текст в Claude (visual mode)

### Управление окнами (Hydra)
- `<leader>ws` - активировать режим управления окнами
  - `hjkl` - навигация между окнами
  - `↑↓←→` - изменение размера
  - `s` - горизонтальное разделение
  - `v` - вертикальное разделение
  - `c` - закрыть окно
  - `o` - закрыть все кроме текущего
  - `=` - выровнять размеры
  - `q`/`Esc` - выход из режима

## Функции

### Автодополнение командной строки
- При вводе `:` появляется выпадающий список команд
- Поддержка fuzzy search
- История команд (при пустой строке)
- Прокрутка и иконки в меню

### Подсказки движений
- Визуальные подсказки доступных Vim движений
- Отображается на активной строке
- Настраиваемые приоритеты подсказок

### Уведомления
- Анимированные уведомления с иконками
- Настраиваемый timeout и стили
- Замена стандартных vim.notify

### Форматирование
- Автоформатирование при сохранении
- Поддержка множества языков через conform.nvim

## Git конфигурация

Репозиторий настроен для пользователя:
- **Имя**: reflaxess123
- **Email**: reflaxess@yandex.ru

## Структура конфигурации

```
~/.config/nvim/
├── init.lua                 # точка входа
├── lua/
│   ├── autocmds.lua        # автокоманды
│   ├── chadrc.lua          # конфиг NvChad
│   ├── mappings.lua        # пользовательские хоткеи
│   ├── options.lua         # настройки vim
│   ├── configs/            # конфигурации плагинов
│   │   ├── conform.lua
│   │   ├── lazy.lua
│   │   └── lspconfig.lua
│   └── plugins/
│       └── init.lua        # список и настройки плагинов
├── lazy-lock.json          # версии плагинов
└── README.md               # этот файл
```

## Установка

1. Убедитесь что установлен Neovim >= 0.9.0
2. Склонируйте этот репозиторий в `~/.config/nvim`
3. Запустите `nvim` - плагины установятся автоматически
4. Перезапустите Neovim

## Кастомизация

- Плагины добавляются в `lua/plugins/init.lua`
- Хоткеи в `lua/mappings.lua`
- Настройки vim в `lua/options.lua`
- Автокоманды в `lua/autocmds.lua`

## Credits

- [NvChad](https://github.com/NvChad/NvChad) - базовый framework
- [LazyVim starter](https://github.com/LazyVim/starter) - вдохновение для структуры