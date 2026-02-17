return {
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            -- Custom theme matching sourcerer.vim palette
            local sourcerer_theme = {
                normal = {
                    a = { fg = "#111111", bg = "#a88af8", gui = "bold" },
                    b = { fg = "#c2c2b0", bg = "#2a2a2a" },
                    c = { fg = "#918175", bg = "#222222" },
                },
                insert = {
                    a = { fg = "#111111", bg = "#87af87", gui = "bold" },
                },
                visual = {
                    a = { fg = "#111111", bg = "#d75f5f", gui = "bold" },
                },
                replace = {
                    a = { fg = "#111111", bg = "#d7875f", gui = "bold" },
                },
                command = {
                    a = { fg = "#111111", bg = "#c2c2b0", gui = "bold" },
                },
                inactive = {
                    a = { fg = "#918175", bg = "#222222" },
                    b = { fg = "#918175", bg = "#222222" },
                    c = { fg = "#918175", bg = "#222222" },
                },
            }

            require("lualine").setup({
                options = {
                    theme = sourcerer_theme,
                    component_separators = { left = "|", right = "|" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff" },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            symbols = { modified = " [+]", readonly = " [RO]" },
                        },
                    },
                    lualine_x = { "diagnostics" },
                    lualine_y = { "filetype" },
                    lualine_z = { "location", "progress" },
                },
            })
        end,
    },
}
