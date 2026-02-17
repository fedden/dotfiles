return {
    -- Commenting: gcc to toggle line, gc in visual mode
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- Multi-cursor
    { "mg979/vim-visual-multi", branch = "master" },

    -- Send code from vim to tmux REPL
    {
        "jpalardy/vim-slime",
        init = function()
            vim.g.slime_target = "tmux"
            vim.g.slime_python_ipython = 1
        end,
    },

    -- Python folding
    { "tmhedberg/SimpylFold" },

    -- Surrounding pairs: cs'" to change, ds" to delete, ysiw) to add
    { "kylechui/nvim-surround", config = true },
}
