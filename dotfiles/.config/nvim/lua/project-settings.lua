local function cerc_settings()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
    end,
  })

  local lint = require("lint")
  local conform = require("conform")
  local rc_path = vim.loop.os_homedir() .. "/Documents/cerc/config/.pylintrc"

  lint.linters_by_ft = { python = { 'pylint' } }
  table.insert(lint.linters.pylint.args, "--rcfile=" .. rc_path)

  conform.formatters.autopep8 = {
    prepend_args = { "--max-line-length=120", "--indent-size=2" }
  }

  print("Cerc settings loaded")
end

vim.api.nvim_create_user_command( 'CercSettings', cerc_settings, {})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local cwd = vim.fn.getcwd()
    local base_path = vim.loop.os_homedir() .. "/Documents/cerc/"

    if cwd:match(base_path) then
      cerc_settings()
    end
  end,
})
