-- Highlight, edit, and navigate code
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    require('nvim-treesitter').install {
      'lua',
      'python',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'regex',
      'terraform',
      'sql',
      'dockerfile',
      'toml',
      'json',
      'java',
      'groovy',
      'go',
      'gitignore',
      'graphql',
      'yaml',
      'make',
      'cmake',
      'c',
      'cpp',
      'markdown',
      'markdown_inline',
      'bash',
      'tsx',
      'css',
      'html',
      'php',
      'vue',
      'dart',
    }

    -- Enable treesitter highlighting and indentation for all filetypes
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    require('nvim-treesitter-textobjects').setup {
      select = { lookahead = true },
      move = { set_jumps = true },
    }

    -- Select keymaps
    vim.keymap.set({ 'x', 'o' }, 'aa', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ia', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'af', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'if', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ac', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ic', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
    end)

    -- Move keymaps
    vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
      require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
      require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
      require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
      require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
    end)

    -- Swap keymaps
    vim.keymap.set('n', '<leader>a', function()
      require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
    end)
    vim.keymap.set('n', '<leader>A', function()
      require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner'
    end)

    -- Register additional file extensions
    vim.filetype.add { extension = { tf = 'terraform' } }
    vim.filetype.add { extension = { tfvars = 'terraform' } }
    vim.filetype.add { extension = { pipeline = 'groovy' } }
    vim.filetype.add { extension = { multibranch = 'groovy' } }
  end,
}
