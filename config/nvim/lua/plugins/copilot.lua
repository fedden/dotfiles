return {
    {
        "github/copilot.vim",
        config = function()
            -- Tab accepts Copilot ghost text (no conflict: nvim-cmp uses C-n/C-p/CR)
            vim.g.copilot_no_tab_map = false
        end,
    },
}
