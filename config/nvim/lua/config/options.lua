-- Leader key: comma
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Diagnostics: show error text inline + float on hover
vim.diagnostic.config({
    virtual_text = { spacing = 2, prefix = "●" },
    signs = true,
    underline = true,
    update_in_insert = false,
    float = { border = "rounded", source = true },
})

-- Show diagnostic float when cursor holds on a line
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end,
})
-- How long (ms) before CursorHold fires (default 4000 is too slow)
vim.opt.updatetime = 300

-- General
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.encoding = "utf-8"
vim.opt.ttyfast = true
vim.opt.showmode = false -- lualine handles mode display
vim.opt.laststatus = 2
vim.opt.mouse = "" -- no mouse
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Default indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.fileformat = "unix"

-- Python: colourcolumn at 88 (matches ruff line-length)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.opt_local.colorcolumn = "88"
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
    end,
})

-- Web (JS/TS/HTML/CSS/JSON): 2-space indent
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "javascript", "javascriptreact",
        "typescript", "typescriptreact",
        "html", "css", "json", "jsonc",
        "prisma",
    },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Terraform / HCL: 2-space indent (hashicorp standard)
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "terraform", "hcl", "terraform-vars" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- YAML / TOML: 2-space indent
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "yaml", "yml", "toml" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Makefiles: must use real tabs
vim.api.nvim_create_autocmd("FileType", {
    pattern = "make",
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
        vim.opt_local.tabstop = 8
        vim.opt_local.softtabstop = 0
    end,
})

-- C/C++: 2-space indent
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Strip trailing whitespace on save for Python
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    command = [[%s/\s\+$//e]],
})

-- .md files as markdown
vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
    pattern = "*.md",
    callback = function()
        vim.bo.filetype = "markdown"
    end,
})
