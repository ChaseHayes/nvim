return {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
        -- load the colorscheme here
        vim.cmd([[colorscheme catppuccin]])
    end,
}
