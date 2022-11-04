local group_name = "autosave_nvim"

local config
local default_config = {
  enabled = true,
  silent = false,
  save_all_buffers = false,
  autosave_events = { "InsertLeave", "TextChanged" },
  postsave_hook = nil,
}

local M = {}

local function autosave()
  if not config.enabled then
    return
  end

  local was_modified = vim.o.modified
  if not was_modified then
    return
  end

  if config.save_all_buffers then
    vim.cmd("silent! bufdo update")
  else
    vim.cmd("silent! update")
  end

  if was_modified and not vim.o.modified then
    if config.postsave_hook and type(config.postsave_hook) == "function" then
      config.postsave_hook()
    end

    if not config.silent then
      vim.api.nvim_echo({ { "[autosave.nvim] Saved at " .. vim.fn.strftime("%H:%M:%S") .. "." } }, true, {})
    end
  end
end

local function enable_autosave()
  config.enabled = true
  vim.api.nvim_echo({ { "[autosave.nvim] autosave enabled." } }, false, {})
end

local function disable_autosave()
  config.enabled = false
  vim.api.nvim_echo({ { "[autosave.nvim] autosave disabled." } }, false, {})
end

---@param user_config table
function M.setup(user_config)
  config = vim.tbl_extend("force", default_config, user_config or {})

  vim.api.nvim_create_augroup(group_name, {})
  vim.api.nvim_create_autocmd(config.autosave_events, {
    group = group_name,
    pattern = "*",
    nested = true,
    callback = function()
      autosave()
    end,
  })

  vim.api.nvim_create_user_command('AutosaveEnable', enable_autosave, {})
  vim.api.nvim_create_user_command('AutosaveDisable', disable_autosave, {})
  vim.api.nvim_create_user_command('AutosaveToggle', function()
    if config.enabled then
      disable_autosave()
    else
      enable_autosave()
    end
  end, {})
end

return M