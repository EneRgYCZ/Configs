-- C and C++ development tools.
-- NOTE: The clangd language server is configured in the `servers` table in lsp.lua.
-- This plugin only adds clangd features that the LSP specification does not include.
return {
  'p00f/clangd_extensions.nvim',
  ft = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  config = function()
    require('clangd_extensions').setup {}

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('clangd-attach', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client or client.name ~= 'clangd' then
          return
        end

        local map = function(keys, cmd, desc)
          vim.keymap.set('n', keys, cmd, { buffer = event.buf, desc = 'C++: ' .. desc })
        end

        map('<leader>ch', '<cmd>LspClangdSwitchSourceHeader<cr>', 'Switch Source/[H]eader')
        map('<leader>ci', '<cmd>ClangdSymbolInfo<cr>', 'Symbol [I]nfo')
        map('<leader>ct', '<cmd>ClangdTypeHierarchy<cr>', '[T]ype Hierarchy')
      end,
    })
  end,
}
