-- Native LSP (0.11+). nvim-lspconfig only supplies the per-server defaults
-- (cmd / filetypes / root_markers via its `lsp/` dir); we enable + tweak natively.
-- Install the server binaries yourself per machine (nix / dnf / npm / rustup / ...);
-- `enable` is lazy, so a missing binary only warns when you open that filetype.
vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig', version = 'v2.10.0' },
    { src = 'https://github.com/j-hui/fidget.nvim', version = 'v2.0.0'},
})

require('fidget').setup {}

-- Per-server overrides, merged onto lspconfig's defaults
vim.lsp.config('clangd', {
    cmd = {
        'clangd',
        '--header-insertion=never'
        -- Add for cross-SDK '--query-driver=/path/to/cross-g++'
    },
    filetypes = { 'c', 'cpp' },
})

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                -- Neovim API + the `vim` global. Broaden to
                -- vim.api.nvim_get_runtime_file('lua', true) to also resolve plugin modules.
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.enable({ 'lua_ls', 'clangd', 'bashls', 'rust_analyzer', 'zls' })

vim.diagnostic.config({
    severity_sort = true,
    virtual_text = true,
})

-- Core's `:lsp` (enable/disable/restart/stop) has no log subcommand; re-add LspLog.
vim.api.nvim_create_user_command('LspLog', function()
    vim.cmd.tabnew(vim.lsp.log.get_filename())
end, { desc = 'Open the LSP log in a new tab' })

-- Buffer-local maps beyond the 0.11 defaults (gra/gri/grn/grr/grt/grx/gO/K/<C-s> are native)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local map = function(lhs, fn, desc)
            vim.keymap.set('n', lhs, fn, { buffer = ev.buf, desc = desc })
        end

        map('grc', vim.lsp.buf.incoming_calls, 'Incoming calls')
        map('grd', vim.lsp.buf.definition, 'Definition')
        map('grD', vim.lsp.buf.declaration, 'Declaration')
        map('grh', function()
            vim.lsp.buf.clear_references()
            vim.lsp.buf.document_highlight()
        end, 'Highlight references')

        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method('textDocument/inlayHint') then
            map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
            end, 'Toggle inlay hints')
        end
    end,
})
