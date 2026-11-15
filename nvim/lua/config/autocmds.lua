--- mini.diff: Add git diff coloring

local function set_minidiff_highlights()
  -- Added lines (vibrant green tint)
  vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { bg = "#203b2c", fg = "NONE" })
  -- Deleted virtual lines (vibrant red tint)
  vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { bg = "#422026", fg = "#f38ba8" })

  -- Word-level diff inside modified lines (old reference vs. new buffer)
  vim.api.nvim_set_hl(0, "MiniDiffOverChange", { bg = "#5c2b33", bold = true })
  vim.api.nvim_set_hl(0, "MiniDiffOverChangeBuf", { bg = "#27523a", bold = true })

  -- Unchanged context on modified lines
  vim.api.nvim_set_hl(0, "MiniDiffOverContext", { bg = "#332227" })
  vim.api.nvim_set_hl(0, "MiniDiffOverContextBuf", { bg = "#1c2e26" })
end

set_minidiff_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("CustomMiniDiffHighlights", { clear = true }),
  callback = set_minidiff_highlights,
})
