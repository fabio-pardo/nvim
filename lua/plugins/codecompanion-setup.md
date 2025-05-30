# CodeCompanion.nvim Setup Guide

## Prerequisites

1. **For Anthropic:**

   - Get your API key from https://console.anthropic.com/
   - Set the environment variable in your shell config (~/.zshrc):
     ```bash
     export ANTHROPIC_API_KEY="your-api-key-here"
     ```

2. **For Ollama:**
   - Install Ollama: `brew install ollama` (macOS) or visit https://ollama.ai/
   - Start Ollama service: `ollama serve`
   - Pull a model: `ollama pull llama3.2:latest`

## Available Keymaps

### General Actions

- `<leader>aa` or `ga` or `<C-a>` - Open CodeCompanion actions menu
- `<leader>ac` - Toggle CodeCompanion chat window
- `<leader>ad` - Add selected code to chat (visual mode)

### Quick Actions (Visual Mode)

- `<leader>ae` - Explain selected code
- `<leader>af` - Fix issues in selected code
- `<leader>ao` - Optimize selected code for performance
- `<leader>ar` - Refactor selected code
- `<leader>at` - Generate tests for selected code
- `<leader>aD` - Document selected code

## Switching Between Adapters

To switch between Anthropic and Ollama:

1. **In chat:** Type `/adapter` and select your preferred adapter
2. **Programmatically:** Update the strategies in the config:
   ```lua
   strategies = {
     chat = { adapter = "ollama" },  -- or "anthropic"
     inline = { adapter = "ollama" }, -- or "anthropic"
   }
   ```

## Available Slash Commands in Chat

- `/buffer` - Include current buffer content
- `/file` - Include a specific file
- `/symbols` - Include symbols from treesitter
- `/terminal` - Include terminal output

## Troubleshooting

1. Run `:checkhealth codecompanion` to verify setup
2. Enable debug logging by changing `log_level = "DEBUG"` in the config
3. Check logs at: `~/.local/state/nvim/codecompanion.log`

## Model Recommendations

### Anthropic Models

- `claude-3-5-sonnet-20241022` - Best overall performance (default)
- `claude-3-haiku-20240307` - Faster, cheaper option

### Ollama Models

- `llama3.2:latest` - Good general purpose model
- `codellama:latest` - Optimized for code
- `deepseek-coder-v2:latest` - Excellent for coding tasks
- `mistral:latest` - Fast and capable

To change models, update the `default` value in the adapter configuration.
