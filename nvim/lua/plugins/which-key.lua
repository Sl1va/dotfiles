return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    opts.delay = function(ctx)
      -- Make delay to show which-key hint greater,
      -- because the default value makes it feel more
      -- like a lug rather than intentional design.
      -- The greater delay will give it time to hit the
      -- combination faster than the hint appears
      return ctx.plugin and 0 or 800
    end
  end,
}
