return {
    {
        "xero/sourcerer.vim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("sourcerer")

            -- Fix float backgrounds to match sourcerer (instead of black)
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2a2a2a", fg = "#c2c2b0" })
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#2a2a2a", fg = "#555555" })
            vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { bg = "#2a2a2a", fg = "#d75f5f" })
            vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { bg = "#2a2a2a", fg = "#d7875f" })
            vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { bg = "#2a2a2a", fg = "#87afaf" })
            vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { bg = "#2a2a2a", fg = "#a88af8" })
        end,
    },
}
