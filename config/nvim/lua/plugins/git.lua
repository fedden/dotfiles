return {
    -- Git commands (:Git blame, :Git log, etc.)
    { "tpope/vim-fugitive" },

    -- Inline git signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "-" },
                    changedelete = { text = "~" },
                },
            })
        end,
    },
}
