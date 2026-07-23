return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', '3rd/image.nvim' },
  ft = { 'markdown' },
  opts = {
    sign = { enabled = false },
    -- heading = { width = 'block' },
    completions = { lsp = { enabled = true } },
  },
}
