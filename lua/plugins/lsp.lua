return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
        config = function()
            require("lspconfig").lua_ls.setup {}
            require("lspconfig").ts_ls.setup {}
            require("lspconfig").dartls.setup {}

            vim.diagnostic.config({
                virtual_text = true
            })

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end)
            vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end)
            vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end)
            vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end)
        end,
    }
}
