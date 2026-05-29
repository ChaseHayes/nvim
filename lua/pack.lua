-- Plugin manager using vim.pack (built-in, Neovim 0.11+)
-- Original plugins backed up in lua/plugins_lazy/

local gh = function(x) return 'https://github.com/' .. x end

-- ---------------------------------------------------------------------------
-- Install all plugins
-- ---------------------------------------------------------------------------

vim.pack.add({
    -- Colorschemes
    gh('catppuccin/nvim'),
    gh('sainnhe/sonokai'),

    -- LSP + completion
    gh('neovim/nvim-lspconfig'),
    gh('folke/lazydev.nvim'),
    gh('hrsh7th/cmp-nvim-lsp'),
    gh('hrsh7th/cmp-buffer'),
    gh('hrsh7th/cmp-path'),
    gh('hrsh7th/cmp-cmdline'),
    gh('hrsh7th/nvim-cmp'),
    gh('williamboman/mason.nvim'),
    gh('williamboman/mason-lspconfig.nvim'),

    -- DAP
    gh('mfussenegger/nvim-dap'),
    gh('rcarriga/nvim-dap-ui'),
    gh('theHamsta/nvim-dap-virtual-text'),
    gh('nvim-neotest/nvim-nio'),

    -- Git
    gh('sindrets/diffview.nvim'),
    gh('tpope/vim-fugitive'),
    gh('airblade/vim-gitgutter'),

    -- Navigation
    { src = gh('ThePrimeagen/harpoon'), version = 'harpoon2' },
    gh('nvim-telescope/telescope.nvim'),
    gh('nvim-telescope/telescope-fzf-native.nvim'),
    gh('nvim-telescope/telescope-ui-select.nvim'),
    gh('nvim-lua/plenary.nvim'),

    -- UI
    gh('j-hui/fidget.nvim'),
    gh('nvim-lualine/lualine.nvim'),
    gh('nvim-tree/nvim-web-devicons'),
    gh('folke/zen-mode.nvim'),
    gh('preservim/nerdtree'),
    gh('MeanderingProgrammer/render-markdown.nvim'),

    -- Editor utilities
    gh('tpope/vim-surround'),
    gh('echasnovski/mini.diff'),

    -- Copilot / AI
    gh('github/copilot.vim'),
    gh('NickvanDyke/opencode.nvim'),
    gh('folke/snacks.nvim'),

    -- ThePrimeagen/99
    gh('ThePrimeagen/99'),
})

-- Build telescope-fzf-native after install/update
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name = ev.data.spec.name
        local kind = ev.data.kind
        if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
            vim.system({ 'make' }, { cwd = ev.data.path })
        end
    end,
})

-- ---------------------------------------------------------------------------
-- Plugin configuration
-- ---------------------------------------------------------------------------

-- sonokai (colorscheme) -------------------------------------------------------
vim.g.sonokai_transparent_background = 1
vim.cmd([[colorscheme sonokai]])

-- copilot ---------------------------------------------------------------------
vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true

-- nerdtree --------------------------------------------------------------------
vim.g.NERDTreeWinSize = 80
vim.g.NERDTreeShowHidden = 1

vim.keymap.set('n', '<leader>nf', function()
    vim.cmd.NERDTreeFind()
end, { desc = 'NERDTreeFind' })

vim.keymap.set('n', '<leader>nr', function()
    vim.cmd.NERDTreeRefreshRoot()
end, { desc = 'NERDTreeRefreshRoot' })

-- diffview --------------------------------------------------------------------
require('diffview').setup()
vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>')
vim.keymap.set('n', '<leader>gD', ':DiffviewFileHistory<CR>')
vim.keymap.set('n', '<leader>gq', ':DiffviewClose<CR>')

-- fidget ----------------------------------------------------------------------
require('fidget').setup({})

-- mini.diff -------------------------------------------------------------------
local diff = require('mini.diff')
diff.setup({ source = diff.gen_source.none() })

-- zen-mode --------------------------------------------------------------------
require('zen-mode').setup({ window = { width = 0.50 } })
vim.keymap.set('n', '<leader>zm', function() vim.cmd.ZenMode() end, { desc = 'Zen Mode' })

-- lualine ---------------------------------------------------------------------
require('lualine').setup({
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = {
            'filetype',
            {
                'lsp_status',
                symbols = { separator = ' | ' },
            },
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
})

-- render-markdown -------------------------------------------------------------
-- (no extra setup needed; loaded for markdown/codecompanion ft automatically)

-- telescope -------------------------------------------------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>pr', builtin.registers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<C-t>', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input('Grep > ') })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

require('telescope').setup({
    defaults = { layout_strategy = 'vertical' },
})
require('telescope').load_extension('ui-select')

-- harpoon (harpoon2) ----------------------------------------------------------
local harpoon = require('harpoon')
harpoon:setup({})

vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
vim.keymap.set('n', '<leader>hj', function() harpoon:list():replace_at(1) end)
vim.keymap.set('n', '<leader>hk', function() harpoon:list():replace_at(2) end)
vim.keymap.set('n', '<leader>hl', function() harpoon:list():replace_at(3) end)
vim.keymap.set('n', '<leader>h;', function() harpoon:list():replace_at(4) end)
vim.keymap.set('n', '<leader>he', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set('n', '<leader>j', function() harpoon:list():select(1) end)
vim.keymap.set('n', '<leader>k', function() harpoon:list():select(2) end)
vim.keymap.set('n', '<leader>l', function() harpoon:list():select(3) end)
vim.keymap.set('n', '<leader>;', function() harpoon:list():select(4) end)
vim.keymap.set('n', '<C-S-P>', function() harpoon:list():prev() end)
vim.keymap.set('n', '<C-S-N>', function() harpoon:list():next() end)

local conf = require('telescope.config').values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end
    require('telescope.pickers').new({}, {
        prompt_title = 'Harpoon',
        finder = require('telescope.finders').new_table({ results = file_paths }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set('n', '<leader>ht', function()
    toggle_telescope(harpoon:list())
end, { desc = 'Open harpoon window' })

-- LSP + nvim-cmp --------------------------------------------------------------
vim.diagnostic.config({
    virtual_text = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = true,
        header = '',
        prefix = '',
    },
})

vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end)
vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end)
vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end)
vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end)
vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end)
vim.keymap.set('n', '<leader>rn', function() vim.lsp.buf.rename() end)
vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end)

local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
    }),
    window = {},
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    }),
})

require('mason').setup()
require('mason-lspconfig').setup({
    automatic_enable = true,
    ensure_installed = { 'lua_ls', 'ts_ls' },
})

-- lazydev (lua LSP enhancements) ----------------------------------------------
require('lazydev').setup({
    library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
})

-- DAP -------------------------------------------------------------------------
local dap = require('dap')
local ui = require('dapui')

ui.setup()
require('nvim-dap-virtual-text').setup({})

vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>gb', dap.run_to_cursor)
vim.keymap.set('n', '<leader>?', function() ui.eval(nil, { enter = true }) end)

vim.keymap.set('n', '<F1>', dap.continue)
vim.keymap.set('n', '<F2>', dap.step_into)
vim.keymap.set('n', '<F3>', dap.step_over)
vim.keymap.set('n', '<F4>', dap.step_out)
vim.keymap.set('n', '<F5>', dap.step_back)
vim.keymap.set('n', '<F13>', dap.restart)
vim.keymap.set('n', '<leader>dt', ui.toggle)

dap.listeners.before.attach.dapui_config = function()
    dap.set_exception_breakpoints({})
end
dap.listeners.before.launch.dapui_config = function()
    dap.set_exception_breakpoints({})
end
dap.listeners.before.event_terminated.dapui_config = function()
    ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    ui.close()
end

-- opencode.nvim ---------------------------------------------------------------
vim.g.opencode_opts = {}
vim.o.autoread = true

vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
    require('opencode').ask('@this: ', { submit = true })
end, { desc = 'Ask opencode' })
vim.keymap.set({ 'n', 'x' }, '<leader>ox', function()
    require('opencode').select()
end, { desc = 'Execute opencode action...' })
vim.keymap.set('n', '<leader>ot', function()
    require('opencode').toggle()
end, { desc = 'Toggle opencode' })
vim.keymap.set('n', '<M-u>', function()
    require('opencode').command('session.half.page.up')
end, { desc = 'opencode half page up' })
vim.keymap.set('n', '<M-d>', function()
    require('opencode').command('session.half.page.down')
end, { desc = 'opencode half page down' })

-- ThePrimeagen/99 -------------------------------------------------------------
local _99 = require('99')

local cwd = vim.uv.cwd()
local basename = vim.fs.basename(cwd)

_99.setup({
    model = 'github-copilot/gpt-5.4',
    logger = {
        level = _99.DEBUG,
        path = '/tmp/' .. basename .. '.99.debug',
        print_on_error = true,
    },
    tmp_dir = './tmp',
    completion = {
        custom_rules = {
            'scratch/custom_rules/',
        },
        files = {},
    },
    md_files = {
        'AGENT.md',
    },
})

vim.keymap.set('v', '<leader>9v', function()
    _99.visual({})
end)

vim.keymap.set('n', '<leader>9x', function()
    _99.stop_all_requests()
end)

vim.keymap.set('n', '<leader>9s', function()
    _99.search({})
end)
