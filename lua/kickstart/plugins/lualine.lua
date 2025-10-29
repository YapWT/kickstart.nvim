return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = {}, -- only ignores the ft for statusline.
          winbar = {}, -- only ignores the ft for winbar.
        },
        ignore_focus = {}, -- If current filetype is in this list it'll always be drawn as inactive statusline and the last window will be drawn as active statusline. For example if you don't want statusline of your file tree / sidebar window to have active statusline you can add their filetypes here. Can also be set to a function that takes the currently focused as its only argument and returns a boolean representing whether the window's statusline should be drawn as inactive.
        always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c' can't take over the entire statusline even if neither of 'x', 'y' or 'z' are present.
        always_show_tabline = true, -- When set to true, if you have configured lualine for displaying tabline then tabline will always show. If set to false, then tabline will be displayed only when there are more than 1 tab. (see :h showtabline)
        globalstatus = false, -- Enable global statusline (have a single statusline at bottom of neovim instead of one for  every window).

        refresh = { -- sets how often lualine should refresh it's contents (in ms)
          statusline = 10000, -- The refresh option sets minimum time that lualine tries
          tabline = 10000, -- to maintain between refresh. It's not guarantied if situation
          winbar = 10000, -- arises that lualine needs to refresh itself before this time it'll do it.
          refresh_time = 16, -- ~60fps the time after which refresh queue is processed. Mininum refreshtime for lualine
          events = {
            'WinEnter', -- Triggered when you enter a window (light)
            'BufEnter', -- Triggered when you enter a buffer (light)
            'BufWritePost', -- Triggered after writing (saving) a buffer (light)
            'SessionLoadPost', -- Triggered after a session is loaded (light)
            'FileChangedShellPost', -- Triggered when an opened file is changed outside Neovim (light)
            'VimResized', -- Triggered when the Neovim window is resized (light)
            'Filetype', -- Triggered when the file type changes (light)
            'CursorMoved', -- Triggered on every cursor move in normal mode (heavy – causes lag)
            'CursorMovedI', -- Triggered on every cursor move in insert mode (heavy – causes lag)
            'ModeChanged', -- Triggered when switching between modes (e.g. Normal → Insert) (medium)
          },
        },
      },

      -- Also you can force lualine's refresh by calling refresh function
      -- like require('lualine').refresh()

      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          'branch',
          {
            'diff',
            colored = true, -- Displays a colored diff status if set to true
            diff_color = {
              -- Same color values as the general color option can be used here.
              added = 'LuaLineDiffAdd', -- Changes the diff's added color
              modified = 'LuaLineDiffChange', -- Changes the diff's modified color
              removed = 'LuaLineDiffDelete', -- Changes the diff's removed color you
            },
            symbols = { added = '+', modified = '~', removed = '-' }, -- Changes the symbols used by the diff.
            source = function()
              local handle = io.popen 'git diff --shortstat'
              local result = handle:read '*a'
              handle:close()

              -- parse "x files changed, y insertions(+), z deletions(-)"
              local added = tonumber(result:match '(%d+) insertions') or 0
              local removed = tonumber(result:match '(%d+) deletions') or 0

              return { added = added, modified = 0, removed = removed }
            end,
          },
          {
            'diagnostics',

            -- Table of diagnostic sources, available sources are:
            --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
            -- or a function that returns a table as such:
            --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
            sources = { 'nvim_diagnostic', 'coc' },

            -- Displays diagnostics for the defined severity types
            sections = { 'error', 'warn', 'info', 'hint' },

            diagnostics_color = {
              -- Same values as the general color option can be used here.
              error = 'DiagnosticError', -- Changes diagnostics' error color.
              warn = 'DiagnosticWarn', -- Changes diagnostics' warn color.
              info = 'DiagnosticInfo', -- Changes diagnostics' info color.
              hint = 'DiagnosticHint', -- Changes diagnostics' hint color.
            },
            symbols = { error = '󰅚 ', warn = '󰀪 ', info = '󰋽 ', hint = '󰌶 ' },
            colored = true, -- Displays diagnostics status in color if set to true.
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = true, -- Show diagnostics even if there are none.
          },
        },
        lualine_c = {
          {
            'filename',
            file_status = true, -- Displays file status (readonly status, modified status)
            newfile_status = true, -- Display new file status (new file means no write after created)
            path = 4, -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = '[+]', -- Text to show when the file is modified.
              readonly = '[Readonly]', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]', -- Text to show for newly created file before first write
            },
          },
        },
        lualine_x = {
          'filesize',
          {
            'lsp_status',
            icon = '', -- f013
            symbols = {
              -- Standard unicode symbols to cycle through for LSP progress:
              spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
              -- Standard unicode symbol for when LSP is done:
              done = '✓',
              -- Delimiter inserted between LSP names:
              separator = ' ',
            },
            -- List of LSP names to ignore (e.g., `null-ls`):
            ignore_lsp = {},
            -- Display the LSP name
            show_name = true,
          },
        },
        lualine_y = { 'location' },
        lualine_z = {
          {
            function()
              return os.date '%H:%M:%S'
            end,
            refresh = {
              statusline = 1000, -- updates once per second
            },
          },
        },
      },
      inactive_sections = {
        lualine_a = {
          {
            'diagnostics',

            -- Table of diagnostic sources, available sources are:
            --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
            -- or a function that returns a table as such:
            --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
            sources = { 'nvim_diagnostic', 'coc' },

            -- Displays diagnostics for the defined severity types
            sections = { 'error', 'warn', 'info', 'hint' },

            diagnostics_color = {
              -- Same values as the general color option can be used here.
              error = 'DiagnosticError', -- Changes diagnostics' error color.
              warn = 'DiagnosticWarn', -- Changes diagnostics' warn color.
              info = 'DiagnosticInfo', -- Changes diagnostics' info color.
              hint = 'DiagnosticHint', -- Changes diagnostics' hint color.
            },
            symbols = { error = '󰅚 ', warn = '󰀪 ', info = '󰋽 ', hint = '󰌶 ' },
            colored = true, -- Displays diagnostics status in color if set to true.
            update_in_insert = true, -- Update diagnostics in insert mode.
            always_visible = true, -- Show diagnostics even if there are none.
          },
        },
        lualine_b = {
          {
            'filename',
            file_status = true, -- Displays file status (readonly status, modified status)
            newfile_status = true, -- Display new file status (new file means no write after created)
            path = 4, -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = '[+]', -- Text to show when the file is modified.
              readonly = '[Readonly]', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]', -- Text to show for newly created file before first write
            },
          },
        },
        lualine_c = {},
        lualine_x = { 'filesize' },
        lualine_y = { 'location' },
        lualine_z = {},
      },

      -- tabline = {
      --   lualine_a = {
      --     {
      --       'buffers',
      --       show_filename_only = true, -- Shows shortened relative path when set to false.
      --       hide_filename_extension = false, -- Hide filename extension when set to true.
      --       show_modified_status = true, -- Shows indicator when the buffer is modified.
      --
      --       mode = 0, -- 0: Shows buffer name
      --       -- 1: Shows buffer index
      --       -- 2: Shows buffer name + buffer index
      --       -- 3: Shows buffer number
      --       -- 4: Shows buffer name + buffer number
      --
      --       max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
      --       -- it can also be a function that returns
      --       -- the value of `max_length` dynamically.
      --       filetype_names = {
      --         TelescopePrompt = 'Telescope',
      --         dashboard = 'Dashboard',
      --         packer = 'Packer',
      --         fzf = 'FZF',
      --         alpha = 'Alpha',
      --       }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
      --
      --       -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
      --       use_mode_colors = true,
      --
      --       symbols = {
      --         modified = ' ●', -- Text to show when the buffer is modified
      --         alternate_file = '#', -- Text to show to identify the alternate file
      --         directory = '', -- Text to show when the buffer is a directory
      --       },
      --     },
      --   },
      --   lualine_b = {},
      --   lualine_c = {},
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = {
      --     {
      --       'lsp_status',
      --       icon = '', -- f013
      --       symbols = {
      --         -- Standard unicode symbols to cycle through for LSP progress:
      --         spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
      --         -- Standard unicode symbol for when LSP is done:
      --         done = '✓',
      --         -- Delimiter inserted between LSP names:
      --         separator = ' ',
      --       },
      --       -- List of LSP names to ignore (e.g., `null-ls`):
      --       ignore_lsp = {},
      --       -- Display the LSP name
      --       show_name = true,
      --     },
      --   },
      -- },
      tabline = nil,
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },

      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {},
    }
  end,
}
