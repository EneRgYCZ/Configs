-- Auto-reload files changed outside Neovim (e.g. by Claude Code or other agents)
vim.o.autoread = true
vim.o.updatetime = 1000 -- also affects CursorHold delay; don't go below 500

local autoreload_group = vim.api.nvim_create_augroup('AutoReload', { clear = true })

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'TermLeave', 'TermClose' }, {
  group = autoreload_group,
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
  desc = 'Check for external file changes on focus/buffer switch',
})

vim.api.nvim_create_autocmd('CursorHold', {
  group = autoreload_group,
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
  desc = 'Check for external file changes during idle',
})

vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = autoreload_group,
  pattern = '*',
  callback = function()
    vim.notify('Buffer reloaded: ' .. vim.fn.expand '<afile>', vim.log.levels.INFO)
  end,
  desc = 'Notify on buffer reload',
})

-- Manually force-check all buffers for external changes
vim.keymap.set('n', '<leader>rr', function()
  vim.cmd 'checktime'
  vim.notify('Checked all buffers for external changes', vim.log.levels.INFO)
end, { desc = 'Reload: check external changes' })
