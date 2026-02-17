local map = vim.keymap.set

-- Disable arrow keys (use h/j/k/l)
map("n", "<Up>", "<NOP>")
map("n", "<Down>", "<NOP>")
map("n", "<Left>", "<NOP>")
map("n", "<Right>", "<NOP>")

-- Escape: clear search highlight + close popups
map("n", "<Esc>", "<cmd>noh<CR><cmd>cclose<CR><cmd>pclose<CR>", { silent = true })

-- fzf mappings
map("n", "<leader>b", "<cmd>Files<CR>", { desc = "Find files" })
map("n", "<leader>n", "<cmd>Rg<CR>", { desc = "Ripgrep search in files" })
map("n", "<leader>m", "<cmd>BLines<CR>", { desc = "Search in current buffer" })

-- Diagnostics
map("n", "<leader>l", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Quick buffer navigation
map("n", "<leader>]", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>[", "<cmd>bprev<CR>", { desc = "Previous buffer" })
