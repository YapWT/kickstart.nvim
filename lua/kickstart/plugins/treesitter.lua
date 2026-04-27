return {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    version = 'v0.10.0',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'bash',
                'c',
                'cpp',
                'java',
                'python',
                'javascript',
                'typescript',
                'html',
                'lua',
                'luadoc',
                'markdown',
                'markdown_inline',
                'query',
                'vim',
                'vimdoc',
                'diff',
            },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = {
                enable = true,
                disable = { 'ruby' }
            },
        })

        vim.opt.foldlevel = 99
        vim.opt.foldlevelstart = 99
        vim.opt.foldenable = true

        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('TS_FOLD_SETUP', { clear = true }),
            callback = function()
                vim.opt_local.foldmethod = 'expr'
                vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            end,
        })

        vim.api.nvim_create_autocmd('BufWinEnter', {
            group = vim.api.nvim_create_augroup('RESTORE_FOLDS', { clear = true }),
            callback = function()
                if vim.bo.filetype == '' or vim.bo.buftype ~= '' then
                    return
                end

                -- Wait for treesitter to be ready
                vim.defer_fn(function()
                    -- Open all folds first
                    vim.cmd('silent! normal! zR')
                    -- Then load the view which will close the saved folds
                    vim.cmd('silent! loadview')
                end, 100)
            end,
        })

        -- Save folds
        vim.api.nvim_create_autocmd('BufWinLeave', {
            group = vim.api.nvim_create_augroup('SAVE_FOLDS', { clear = true }),
            callback = function()
                -- Only save view for actual files
                if vim.bo.filetype ~= '' and vim.bo.buftype == '' then
                    vim.cmd('silent! mkview')
                end
            end,
        })
    end,
}
-- Note: if fold not working as expected
-- consider 'kevinhwang91/nvim-ufo' instead of pretty-fold
