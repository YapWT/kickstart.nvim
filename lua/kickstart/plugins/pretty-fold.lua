return {
    {
        'anuvyklack/pretty-fold.nvim',
        event = 'BufReadPost',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('pretty-fold').setup {
                sections = {
                    left = {
                        'content',
                    },
                    right = {
                        ' ',
                        'number_of_folded_lines',
                        ': ',
                        'percentage',
                        ' ',
                        function(config)
                            return config.fill_char:rep(3)
                        end,
                    },
                },
                fill_char = '•',
                remove_fold_markers = true,
                -- Keep the indentation of the content of the fold string.
                keep_indentation = true,
                -- "delete" | "spaces" | false
                process_comment_signs = 'spaces',
                comment_signs = {},
                stop_words = {
                    '@brief%s*',
                },
                add_close_pattern = true, -- true | 'last_line' | false
                matchup_patterns = {
                    { '{',  '}' },
                    { '%(', ')' },
                    { '%[', ']' },
                },
                ft_ignore = { 'neorg' },
            }
        end,
    },
}
