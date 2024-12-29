return {
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      local blame = require('blame')
      blame.setup {}
      vim.keymap.set('n', '<leader>gb', function()
			vim.cmd('BlameToggle')
      end, {})
    end,
  },
}
