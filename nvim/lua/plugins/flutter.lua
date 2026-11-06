-- Flutter and Dart development tools.
-- NOTE: flutter-tools starts and configures the Dart language server (dartls) itself.
-- Do not add `dartls` to the `servers` table in lsp.lua, or two servers will attach.
return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local format_augroup = vim.api.nvim_create_augroup('DartFormatting', {})

    require('flutter-tools').setup {
      ui = {
        border = 'rounded',
      },
      -- Draw vertical guide lines between a widget and its children
      widget_guides = {
        enabled = true,
      },
      -- Show `// Widget` virtual text at the closing bracket of each widget
      closing_tags = {
        prefix = '// ',
        enabled = true,
      },
      -- Log output of `flutter run`
      dev_log = {
        enabled = true,
        notify_errors = false,
        open_cmd = '15split',
        focus_on_open = false,
      },
      dev_tools = {
        autostart = false,
        auto_open_browser = false,
      },
      outline = {
        open_cmd = '40vnew',
        auto_open = false,
      },
      -- Set `enabled = true` to run the app through nvim-dap (breakpoints, dap-ui)
      debugger = {
        enabled = false,
        exception_breakpoints = {},
      },
      lsp = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Show the colour of `Colors.x` / `Color(0x...)` values in the buffer
          vim.lsp.document_color.enable(true, { bufnr = bufnr })

          -- Format on save, same behaviour as the none-ls formatters
          vim.api.nvim_clear_autocmds { group = format_augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = format_augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false, id = client.id }
            end,
          })
        end,
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = 'prompt',
          enableSnippets = true,
          updateImportsOnRename = true,
        },
      },
    }

    require('telescope').load_extension 'flutter'

    local map = function(keys, cmd, desc)
      vim.keymap.set('n', keys, cmd, { desc = 'Flutter: ' .. desc })
    end

    map('<leader>Fc', '<cmd>Telescope flutter commands<cr>', 'Commands Picker')
    map('<leader>Fr', '<cmd>FlutterRun<cr>', 'Run')
    map('<leader>Fd', '<cmd>FlutterDevices<cr>', 'Devices')
    map('<leader>Fe', '<cmd>FlutterEmulators<cr>', 'Emulators')
    map('<leader>Fh', '<cmd>FlutterReload<cr>', 'Hot Reload')
    map('<leader>FR', '<cmd>FlutterRestart<cr>', 'Hot Restart')
    map('<leader>Fq', '<cmd>FlutterQuit<cr>', 'Quit')
    map('<leader>Fo', '<cmd>FlutterOutlineToggle<cr>', 'Widget Outline')
    map('<leader>Fl', '<cmd>FlutterLogToggle<cr>', 'Toggle Log')
    map('<leader>Ft', '<cmd>FlutterDevTools<cr>', 'DevTools')
    map('<leader>Fp', '<cmd>FlutterPubGet<cr>', 'Pub Get')
    map('<leader>Fs', '<cmd>FlutterSuper<cr>', 'Go to Super')
    map('<leader>Fx', '<cmd>FlutterLspRestart<cr>', 'Restart Dart LSP')
  end,
}
