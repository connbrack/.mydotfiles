local function cerc_settings()

  -- set cerc settings
  vim.opt.fixendofline = false

  --  set python shiftwidth
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.expandtab = true
    end,
  })

  -- activate pylint
  local rc_path = vim.loop.os_homedir() .. "/Documents/cerc/config/.pylintrc"
  local lint = require("lint")
  lint.linters_by_ft = lint.linters_by_ft or {}
  lint.linters_by_ft.python = { "pylint" }
  lint.linters.pylint.args = lint.linters.pylint.args or {}
  table.insert(lint.linters.pylint.args, "--rcfile=" .. rc_path)

  -- activate custom rules for prettier
  local ok_conform, conform = pcall(require, "conform")
  if ok_conform then
    conform.formatters.autopep8 = {
      prepend_args = { "--max-line-length=120", "--indent-size=2" }
    }
  else
    vim.notify("conform.nvim not found", vim.log.levels.WARN)
    return
  end

  print("Cerc settings loaded")
end

-- create user command
vim.api.nvim_create_user_command('CercSettings', cerc_settings, {})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local cwd = vim.fn.getcwd()
    local base_path = vim.loop.os_homedir() .. "/Documents/cerc/"

    if cwd:match(base_path) then
      cerc_settings()
    end
  end,
})
