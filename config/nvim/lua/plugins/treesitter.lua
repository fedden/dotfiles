return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install({
                "python", "javascript", "typescript", "tsx",
                "html", "css", "c", "cpp", "cmake", "rust",
                "terraform", "hcl", "json", "yaml", "toml",
                "dockerfile", "bash", "markdown", "markdown_inline",
                "sql", "lua", "make",
            })

            -- Enable treesitter highlighting for all supported filetypes
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
}
