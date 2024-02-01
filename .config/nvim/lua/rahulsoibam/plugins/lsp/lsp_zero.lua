return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "neovim/nvim-lspconfig" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/nvim-cmp" },
        { "L3MON4D3/LuaSnip" },
        { "antosha417/nvim-lsp-file-operations",      config = true },
        { "williamboman/mason-lspconfig.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    },

    config = function()
        local lsp_zero = require("lsp-zero")
        local lspconfig = require("lspconfig")

        -- import mason
        local mason = require("mason")

        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")

        local mason_tool_installer = require("mason-tool-installer")

        local telescope_builtin = require("telescope.builtin")

        lsp_zero.set_preferences({
            suggest_lsp_servers = false,
            sign_icons = {
                error = "E",
                warn = "W",
                hint = "H",
                info = "I",
            },
        })

        lsp_zero.on_attach(function(_, bufnr)
            local nmap = function(keys, func, desc)
                if desc then
                    desc = "LSP: " .. desc
                end

                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            end
            nmap("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
            nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")

            nmap("gd", telescope_builtin.lsp_definitions, "[g]oto [d]efinition")
            nmap("gr", telescope_builtin.lsp_references, "[g]oto [r]eferences")
            nmap("gi", telescope_builtin.lsp_implementations, "[g]oto [i]mplementation")
            nmap("<leader>D", telescope_builtin.lsp_type_definitions, "Type [D]efinition")
            nmap("<leader>ds", telescope_builtin.lsp_document_symbols, "[d]ocument [s]ymbols")
            nmap("<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")

            -- See `:help K` for why this keymap
            nmap("K", vim.lsp.buf.hover, "Hover Documentation")
            nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

            -- Lesser used LSP functionality
            nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
            nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
            nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
            nmap("<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, "[W]orkspace [L]ist Folders")

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                vim.lsp.buf.format()
            end, { desc = "Format current buffer with LSP" })
        end)

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_tool_installer.setup({
            -- list of servers for mason to install
            ensure_installed = {
                "lua_ls",
                "bashls", -- need to install shellcheck for linting to work
                "gopls",
                "gofumpt",
                "goimports", -- needed for goimports-reviser to work
                "goimports-reviser",
                "golines",
                "rust_analyzer",
                "clangd",
                "stylua",
                "pyright",
                "black",
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })

        mason_lspconfig.setup({
            handlers = {
                lsp_zero.default_setup,
            },
        })

        -- lua_ls setup
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        })

        lspconfig.gopls.setup({
            settings = {
                gopls = {
                    completeUnimported = true,
                    usePlaceholders = true,
                    analyses = {
                        unusedparams = true,
                    },
                },
            },
        })
    end,
}
