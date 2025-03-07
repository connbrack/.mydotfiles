return {
  {
    "goolord/alpha-nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local startify = require("alpha.themes.startify")
      startify.file_icons.provider = "devicons"
      startify.section.header.val = {
      [[                                       ]],
      [[         |\      _,,,---,,_            ]],
      [[   ZZZzz /,`.-'`'    -.  ;-;;,_        ]],
      [[        |,4-  ) )-,_. ,\ (  `'-'       ]],
      [[       '---''(_/--'  `-'\_)            ]],

      }
      require("alpha").setup(startify.config)
    end,
  },
}
