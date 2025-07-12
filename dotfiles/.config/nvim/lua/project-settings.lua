local function cerc_settings()

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
    end,
  })

  local rc_path = vim.loop.os_homedir() .. "/Documents/cerc/config/.pylintrc"
  local ok_lint, lint = pcall(require, "lint")
  if ok_lint then
    lint.linters_by_ft = { python = { 'pylint' } }
    if lint.linters.pylint then
      table.insert(lint.linters.pylint.args, "--rcfile=" .. rc_path)
    else
      vim.notify("Pylint linter not configured in nvim-lint", vim.log.levels.WARN)
    end
  else
    vim.notify("nvim-lint not found", vim.log.levels.WARN)
  end

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
