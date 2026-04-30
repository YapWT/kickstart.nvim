return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        -- This pcall ensures Neovim doesn't explode if the plugin is still downloading
        local ok, configs = pcall(require, 'nvim-treesitter.configs')
        if not ok then return end

        configs.setup({
            ensure_installed = { 'bash', 'c', 'cpp', 'java', 'python', 'javascript', 'typescript', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'diff', 'toml' },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
