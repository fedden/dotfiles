return {
    {
        "junegunn/fzf",
        build = function()
            vim.fn["fzf#install"]()
        end,
    },
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        config = function()
            -- Use rg for :Files (respects .gitignore + .ignore files)
            vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git'"

            -- Colours that blend with sourcerer
            vim.g.fzf_colors = {
                fg = { "fg", "Normal" },
                bg = { "bg", "Normal" },
                ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
                ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
                info = { "fg", "PreProc" },
                border = { "fg", "Ignore" },
                prompt = { "fg", "Conditional" },
                pointer = { "fg", "Exception" },
                marker = { "fg", "Keyword" },
                spinner = { "fg", "Label" },
                header = { "fg", "Comment" },
            }
        end,
    },
}
