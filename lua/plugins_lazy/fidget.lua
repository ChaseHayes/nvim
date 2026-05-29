-- Fidget plugin setup for Neovim
return {
    "j-hui/fidget.nvim",
    tag = "legacy", -- Use legacy for stability, or omit for latest
    config = function()
        require("fidget").setup({})
    end,
    event = "LspAttach", -- Lazy load on LSP attach
}
