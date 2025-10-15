return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },

  config = function()
    require('telescope').setup {
      defaults = {
        prompt_prefix = '🔍 ',
        selection_caret = ' ',
        path_display = { 'smart' },

        -- Consistent horizontal split layout
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = {
            prompt_position = 'bottom',
            preview_width = 0.55,
            results_width = 0.8,
          },
          width = 0.95,
          height = 0.85,
          preview_cutoff = 120,
        },

        mappings = {
          i = {
            ['<C-j>'] = 'move_selection_next',
            ['<C-k>'] = 'move_selection_previous',
            ['<C-q>'] = 'send_to_qflist',
          },
          n = {
            ['q'] = 'close',
          },
        },
      },

      pickers = {
        find_files = {
          -- Removed theme to use default horizontal layout
        },
        buffers = {
          sort_lastused = true,
        },
        live_grep = {},
        grep_string = {},
        current_buffer_fuzzy_find = {},
      },

      extensions = {
        ['fzf'] = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Load extensions
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'frecency')
    pcall(require('telescope').load_extension, 'projects')
    pcall(require('telescope').load_extension, 'file_browser')

    -- Built-in pickers keymaps
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Current buffer fuzzy search (no dropdown theme)
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find {
        winblend = 10,
      }
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- Live grep in open files
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Neovim configuration files search
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    -- Extension keymaps (if installed)
    vim.keymap.set('n', '<leader>ffr', function()
      require('telescope').extensions.frecency.frecency()
    end, { desc = '[F]recency Files' })

    vim.keymap.set('n', '<leader>fp', function()
      require('telescope').extensions.project.project { display_type = 'full' }
    end, { desc = '[F]ind [P]rojects' })

    vim.keymap.set('n', '<leader>fbf', function()
      require('telescope').extensions.file_browser.file_browser()
    end, { desc = '[F]ile [B]rowser' })
  end,
}
