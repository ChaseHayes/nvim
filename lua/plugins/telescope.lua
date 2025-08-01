return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    requires = {
        { 'nvim-lua/plenary.nvim' },
    },
    dependencies = {
        { 'nvim-telescope/telescope-ui-select.nvim' }
    },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<C-t>', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        require('telescope').setup {
            defaults = {
                layout_strategy = 'vertical',
            }
        }

        require('telescope').load_extension('ui-select')
    end,
}
