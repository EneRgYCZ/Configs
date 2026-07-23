return {
  '3rd/image.nvim',
  lazy = false,
  opts = {
    backend = 'kitty', -- Ghostty implements Kitty graphics protocol
    processor = 'magick_cli',
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = true,
        download_remote_images = false,
        only_render_image_at_cursor = false,
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = 80,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    editor_only_render_when_focused = true,
    tmux_show_only_in_active_window = true,
  },
}
