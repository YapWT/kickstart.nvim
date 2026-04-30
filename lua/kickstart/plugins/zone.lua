return {
  "tamton-aquib/zone.nvim",
  config = function()
    require("zone").setup({
      style = "matrix", -- Change 'vanish' to 'matrix'
      after = 600, 
    })
  end,
}
