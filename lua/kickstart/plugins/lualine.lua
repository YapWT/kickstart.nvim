return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  init = function()
    -- 1. THE SHIELD: Prevents Neo-tree crash on 0.13-dev
    pcall(vim.api.nvim_create_autocmd, "User", { pattern = "BufModifiedSet" })

    -- 2. TMUX TOGGLE: Hide bar on start, show on exit
    if vim.env.TMUX then
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.fn.system("tmux set status off")
        end,
      })
      vim.api.nvim_create_autocmd("VimLeave", {
        callback = function()
          vim.fn.system("tmux set status on")
        end,
      })
    end
  end,

  config = function()
    vim.api.nvim_create_autocmd({ "VimResized", "VimEnter" }, {
      callback = function()
        vim.schedule(function()
          vim.cmd("redraw!")
        end)
      end,
    })

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          'branch',
          {
            'diff',
            colored = true,
            symbols = { added = '+', modified = '~', removed = '-' },
          },
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = { error = '󰅚 ', warn = '󰀪 ', info = '󰋽 ', hint = '󰌶 ' },
          },
        },
        lualine_c = {
          {
            'filename',
            file_status = true,
            path = 4, -- Filename and parent dir
          },
        },
        lualine_x = {
          'filesize',
          {
            'lsp_status',
            icon = '',
            done = '✓',
          },
        },
        lualine_y = { 'location' },
        lualine_z = {
          {
            function() return os.date '%H:%M:%S' end,
          },
        },
      },
    }
  end,
}
