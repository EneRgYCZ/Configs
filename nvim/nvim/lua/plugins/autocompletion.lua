return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  -- event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      -- follow latest release.
      version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = 'make install_jsregexp',
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local cmp = require 'cmp'
    require('luasnip.loaders.from_vscode').lazy_load()
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    local kind_icons = {
      Text = '󰉿',
      Method = 'm',
      Function = '󰊕',
      Constructor = '',
      Field = '',
      Variable = '󰆧',
      Class = '󰌗',
      Interface = '',
      Module = '',
      Property = '',
      Unit = '',
      Value = '󰎠',
      Enum = '',
      Keyword = '󰌋',
      Snippet = '',
      Color = '󰏘',
      File = '󰈙',
      Reference = '',
      Folder = '󰉋',
      EnumMember = '',
      Constant = '󰇽',
      Struct = '',
      Event = '',
      Operator = '󰆕',
      TypeParameter = '󰊄',
    }

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },
      -- window = {
      --     completion = cmp.config.window.bordered(),
      --     documentation = cmp.config.window.bordered(),
      -- },
      mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(), -- Select the [n]ext item
        ['<C-k>'] = cmp.mapping.select_prev_item(), -- Select the [p]revious item
        ['<CR>'] = cmp.mapping(function(fallback)
          if not cmp.visible() then
            fallback()
            return
          end

          local entry = cmp.get_selected_entry()
          if not entry then
            cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
            return
          end

          -- Snapshot the item before confirming — cmp may clear it after insertion.
          local item = vim.deepcopy(entry:get_completion_item())
          local bufnr = vim.api.nvim_get_current_buf()

          cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })

          -- If additionalTextEdits were already on the item at confirm time, nvim-cmp's
          -- built-in LSP confirm already applied them — don't double-apply.
          if item.additionalTextEdits and #item.additionalTextEdits > 0 then return end

          -- Slow path: phpactor only ships additionalTextEdits via completionItem/resolve,
          -- not in the initial list. If the item wasn't pre-resolved before confirm, nvim-cmp
          -- couldn't apply them, so we request resolve ourselves and apply the result.
          if entry.source.name ~= 'nvim_lsp' then return end
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if client:supports_method('completionItem/resolve') then
              client:request('completionItem/resolve', item, function(err, resolved)
                if err or not resolved or not resolved.additionalTextEdits then return end
                vim.schedule(function()
                  vim.lsp.util.apply_text_edits(
                    resolved.additionalTextEdits,
                    bufnr,
                    client.offset_encoding or 'utf-8'
                  )
                end)
              end, bufnr)
              return
            end
          end
        end, { 'i' }), -- Accept the completion with Enter.
        ['<C-c>'] = cmp.mapping.complete {}, -- Manually trigger a completion from nvim-cmp.

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- Select next/previous item with Tab / Shift + Tab
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
          -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            luasnip = '[Snippet]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]
          return vim_item
        end,
      },
    }
  end,
}
