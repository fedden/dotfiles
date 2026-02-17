return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    -- nvim-lspconfig registers default server configs (cmd, filetypes, root_markers)
    { "neovim/nvim-lspconfig" },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            -- Find a binary in .venv/bin/ by searching upward from cwd,
            -- then checking immediate subdirectories (monorepo pattern).
            -- Falls back to the bare name (relies on Mason / PATH).
            local function find_venv_bin(name)
                local dir = vim.fn.getcwd()
                -- Walk upward from cwd
                local search = dir
                while search ~= "/" do
                    local bin = search .. "/.venv/bin/" .. name
                    if vim.uv.fs_stat(bin) then
                        return bin
                    end
                    search = vim.fn.fnamemodify(search, ":h")
                end
                -- Check immediate subdirectories (monorepo pattern)
                local hits = vim.fn.glob(dir .. "/*/.venv/bin/" .. name, false, true)
                if #hits > 0 then
                    return hits[1]
                end
                return name
            end

            -- Set nvim-cmp capabilities for ALL LSP servers
            vim.lsp.config("*", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            -- Python: ruff (lint + format) and ty (type checking)
            -- Both prefer .venv binaries to match project-pinned versions.
            local ruff_bin = find_venv_bin("ruff")
            vim.lsp.config("ruff", {
                cmd = { ruff_bin, "server" },
                root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
                init_options = {
                    settings = {
                        lineLength = 88,
                    },
                },
            })

            local ty_bin = find_venv_bin("ty")
            vim.lsp.config("ty", {
                cmd = { ty_bin, "server" },
                filetypes = { "python" },
                root_markers = { "pyproject.toml", "ty.toml", ".git" },
                settings = {
                    ty = {
                        diagnosticMode = "workspace",
                    },
                },
            })
            vim.lsp.enable("ty")

            -- Lua (nvim config editing)
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            })

            -- YAML: GitHub Actions schema support
            vim.lsp.config("yamlls", {
                settings = {
                    yaml = {
                        keyOrdering = false,
                        schemas = {
                            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                            ["https://json.schemastore.org/github-action.json"] = "action.{yml,yaml}",
                        },
                    },
                },
            })

            -- Mason: install all servers; mason-lspconfig auto-enables them
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ruff",          -- Python lint + format
                    "ts_ls",         -- TypeScript / JavaScript
                    "eslint",        -- TS/JS linting
                    "clangd",        -- C/C++
                    "rust_analyzer", -- Rust
                    "terraformls",   -- Terraform / HCL
                    "yamlls",        -- YAML
                    "jsonls",        -- JSON
                    "cmake",         -- CMake
                    "dockerls",      -- Dockerfiles
                    "lua_ls",        -- Lua
                },
            })

            -- LSP keymaps set when a server attaches to a buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                end,
            })
        end,
    },
}
