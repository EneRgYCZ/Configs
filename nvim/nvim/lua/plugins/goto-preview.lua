return {
  "rmagatti/goto-preview",
  config = function()
    require("goto-preview").setup {}
    vim.keymap.set("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
    vim.keymap.set("n", "gpc", "<cmd>lua require('goto-preview').close_all_win()<CR>")
  end
}
