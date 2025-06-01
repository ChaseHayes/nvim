return {
    'nvim-flutter/flutter-tools.nvim',
    config = function()
        require('flutter-tools').setup({
            flutter_lookup_cmd = "asdf where flutter",  -- example "dirname $(which flutter)" or "asdf where flutter"
            root_patterns = { ".git", "pubspec.yaml" }, -- patterns to find the root of your flutter project
        })
    end,
}
