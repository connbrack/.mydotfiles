local function make_pretty()
  local ft = vim.bo.filetype

  if ft == "csv" then
    vim.cmd("CsvViewToggle")
  elseif ft == "markdown" then
    vim.cmd("RenderMarkdown toggle")
  else
    print("No pretty defined for this filetype: " .. ft)
  end
end

local function open_preview()
  local ft = vim.bo.filetype

  if ft == "markdown" then
    vim.cmd("MarkdownPreview")
    print("Opening markdown preview")
  elseif ft == "typst" then
    vim.cmd("TypstPreview")
    print("Opening typst preview")
  else
    print("No preview defined for this filetype: " .. ft)
  end
end

vim.keymap.set("n", ",p", make_pretty, { noremap = true, silent = true })
vim.keymap.set("n", ",P", open_preview, { noremap = true, silent = true })
