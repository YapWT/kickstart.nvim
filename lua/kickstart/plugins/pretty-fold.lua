return {
    {
        'anuvyklack/pretty-fold.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('pretty-fold').setup {
                sections = {
                    left = { 'content' },
                    right = {
                        ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
                        function(config) return config.fill_char:rep(3) end,
                    },
                },
                fill_char = '•',
                remove_fold_markers = true,
                keep_indentation = true,
                process_comment_signs = 'spaces',
                add_close_pattern = true,
                matchup_patterns = {
                    { '{', '}' }, { '%(', ')' }, { '%[', ']' },
                },
            }

            -- GLOBAL SETTINGS
            vim.opt.viewoptions = 'folds,cursor,curdir,slash,unix'
            vim.opt.foldlevel = 99 -- Everything open by default
            vim.opt.foldlevelstart = 99 -- Everything open by default
            vim.opt.foldenable = true

            -- 1. SAVE FOLDS: Automatically save when leaving or writing
            vim.api.nvim_create_autocmd({ 'BufWinLeave', 'BufWritePost' }, {
                group = vim.api.nvim_create_augroup('PersistFoldsSave', { clear = true }),
                callback = function(args)
                    if vim.bo[args.buf].buftype == '' and vim.bo[args.buf].filetype ~= '' then
                        pcall(vim.cmd, 'mkview')
                    end
                end,
            })

            -- 2. RESTORE FOLDS: Only restore what you specifically folded
            vim.api.nvim_create_autocmd('BufWinEnter', {
                group = vim.api.nvim_create_augroup('PersistFoldsLoad', { clear = true }),
                callback = function(args)
                    if vim.bo[args.buf].buftype == '' then
                        -- Crucial: Wait 100ms so the UI stabilizes to prevent exploding text
                        vim.defer_fn(function()
                            if vim.api.nvim_buf_is_valid(args.buf) then
                                pcall(vim.cmd, 'loadview')
                                vim.cmd('redraw!') -- Force redraw to fix any character scattering
                            end
                        end, 100)
                    end
                end,
            })

            -- 3. SET FOLD METHOD: Use Treesitter for the actual logic
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    vim.opt_local.foldmethod = 'expr'
                    vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                end,
            })
        end,
    },
}
