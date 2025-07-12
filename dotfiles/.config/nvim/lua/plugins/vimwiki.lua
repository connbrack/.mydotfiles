return {
  {
    "vimwiki/vimwiki",
    init = function()
      local wikipath = vim.fn.fnamemodify(vim.fn.expand("~/Documents/vimwiki"), ":p") .. "/"

      vim.g.vimwiki_list = {
        {
          path = wikipath,
          syntax = "markdown",
          ext = ".md",
        },
      }
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_use_syntax = 0
    end,
  }
}
