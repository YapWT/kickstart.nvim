return {
  {
    'echasnovski/mini.nvim',
    -- Collection of various small independent plugins/modules 'echasnovski/mini.nvim',
    config = function()
      -- Core text editing
      require('mini.ai').setup {
        -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
        mappings = {
          around_next = 'aa',
          inside_next = 'ii',
        },
        n_lines = 500,
      }
      -- require('mini.align').setup()
      -- require('mini.comment').setup()
      -- require('mini.completion').setup()
      -- require('mini.keymap').setup()
      require('mini.move').setup()
      -- require('mini.operators').setup()
      -- require('mini.pairs').setup()
      -- require('mini.snippets').setup()
      -- require('mini.splitjoin').setup()
      require('mini.surround').setup()

      -- Basics & navigation
      -- require('mini.basics').setup()
      require('mini.bracketed').setup()
      -- require('mini.bufremove').setup()
      -- require('mini.clue').seup()
      -- require('mini.cmdline').setup()
      -- require('mini.deps').setup()
      -- require('mini.diff').setup()
      -- require('mini.extra').setup()
      -- require('mini.files').setup()
      require('mini.git').setup()
      -- require('mini.jump').setup()
      -- require('mini.jump2d').setup()
      -- require('mini.misc').setup()
      -- require('mini.pick').setup()
      -- require('mini.sessions').setup()
      -- require('mini.visits').setup()

      -- Appearance
      -- require('mini.animate').setup()
      -- require('mini.base16').setup()
      -- require('mini.colors').setup()
      -- require('mini.cursorword').setup()
      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(), -- ('#ffffff')
        },
      }

      -- require('mini.hues').setup()
      -- require('mini.icons').setup()
      -- require('mini.indentscope').setup()
      -- require('mini.map').setup()
      -- require('mini.notify').setup()
      -- require('mini.starter').setup()
      require('mini.statusline').setup()
      -- require('mini.tabline').setup()
      -- require('mini.trailspace').setup()

      -- Other
      -- require('mini.doc').setup()
      -- require('mini.fuzzy').setup()
      -- require('mini.test').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
