# ⚡ Neovim Configuration

A standalone Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim).

> Migrated from LazyVim to a fully explicit configuration for complete ownership and customisation.

## Requirements

- Neovim >= 0.11.2 (built with LuaJIT)
- Git >= 2.19.0
- [Nerd Font](https://www.nerdfonts.com/) (v3.0+)
- [ripgrep](https://github.com/BurntSushi/ripgrep) for grep/search
- [fd](https://github.com/sharkdp/fd) for file finding
- [lazygit](https://github.com/jesseduffield/lazygit) (optional)

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua     # Autocommands
│   │   ├── keymaps.lua      # Key mappings
│   │   ├── lazy.lua         # Plugin manager bootstrap
│   │   └── options.lua      # Neovim options
│   ├── plugins/             # Plugin specifications
│   │   ├── coding.lua       # mini.pairs, mini.ai, ts-comments, lazydev
│   │   ├── completion.lua   # blink.cmp
│   │   ├── copilot.lua      # GitHub Copilot
│   │   ├── editor.lua       # flash, gitsigns, trouble, todo-comments, which-key
│   │   ├── formatting.lua   # conform.nvim
│   │   ├── gruvbox.lua      # Colorscheme
│   │   ├── linting.lua      # nvim-lint
│   │   ├── lsp.lua          # LSP, Mason
│   │   ├── snacks.lua       # Snacks (picker, dashboard, toggles, etc.)
│   │   ├── treesitter.lua   # Syntax highlighting
│   │   ├── ui.lua           # bufferline, lualine, noice
│   │   ├── yanky.lua        # Better yank/paste
│   │   └── ...              # Custom plugins (obsidian, codecompanion, etc.)
│   └── util/                # Utility modules
└── stylua.toml              # Lua formatter config
```

## Key Mappings

Leader key: `<Space>`

| Key | Description |
|-----|-------------|
| `<leader><space>` | Find files |
| `<leader>/` | Grep |
| `<leader>e` | File explorer |
| `<leader>gg` | Lazygit |
| `<leader>cf` | Format |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename |
| `<leader>xx` | Diagnostics (Trouble) |
| `s` | Flash jump |
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover documentation |

Press `<leader>` to see all available keymaps via which-key.

## Custom Plugins

- **Obsidian** (`<leader>o`) - Note-taking integration
- **CodeCompanion** (`<leader>a`) - AI assistant
- **Auto-session** - Automatic session management
- **vim-tmux-navigator** - Seamless tmux/vim navigation

## Credits

Originally based on [LazyVim](https://github.com/LazyVim/LazyVim) by Folke Lemaitre.
