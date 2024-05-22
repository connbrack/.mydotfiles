return {
  {
    'numToStr/Comment.nvim',
    opts = {
      ---Add a space b/w comment and the line
      padding = false,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      toggler = {
        line = '<C-_>',
        -- block = '<C-?>',
      },
      opleader = {
        line = '<C-_>',
        --block = '<C-?>',
      },
      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
      ---Function to call before (un)comment
      pre_hook = nil,
      ---Function to call after (un)comment
      post_hook = nil,
    },
    lazy = false,
  }
}
