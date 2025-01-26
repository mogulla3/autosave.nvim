local group_name = "autosave_nvim"
local config
local default_config = {
  enabled = true,
  silent = false,
  autosave_events = { "InsertLeave", "TextChanged", "CursorHold" },
  postsave_hook = nil,
}

local M = {}

local function autosave()
  if not config.enabled then
    return
  end

  -- Skip unnamed buffer
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then
    return
  end

  local was_modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
  if not was_modified then
    return
  end

  vim.cmd("silent! update")

  if was_modified and not vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
    if config.postsave_hook then
      config.postsave_hook()
    end

    if not config.silent then
      vim.api.nvim_echo({ { "[autosave.nvim] Saved at " .. vim.fn.strftime("%H:%M:%S") } }, true, {})
    end
  end
end

local function enable_autosave()
  config.enabled = true
  vim.api.nvim_echo({ { "[autosave.nvim] autosave enabled" } }, false, {})
end

local function disable_autosave()
  config.enabled = false
  vim.api.nvim_echo({ { "[autosave.nvim] autosave disabled" } }, false, {})
end

local function validate_config()
  -- FIXME: In Neovim 0.11, the current usage of vim.validate() will be deprecated.
  -- https://neovim.io/doc/user/deprecated.html#deprecated-0.11
  -- https://neovim.io/doc/user/lua.html#vim.validate()
  vim.validate({
    enabled = { config.enabled, "boolean" },
    silent = { config.silent, "boolean" },
    autosave_events = { config.autosave_events, "table" },
    postsave_hook = { config.postsave_hook, { "function" }, true },
  })
end

---@param user_config table
function M.setup(user_config)
  config = vim.tbl_extend("force", default_config, user_config or {})

  validate_config()

  vim.api.nvim_create_augroup(group_name, {})
  vim.api.nvim_create_autocmd(config.autosave_events, {
    group = group_name,
    pattern = "*",
    nested = true,
    callback = function()
      autosave()
    end,
  })

  vim.api.nvim_create_user_command("AutosaveEnable", enable_autosave, {})
  vim.api.nvim_create_user_command("AutosaveDisable", disable_autosave, {})
  vim.api.nvim_create_user_command("AutosaveToggle", function()
    if config.enabled then
      disable_autosave()
    else
      enable_autosave()
    end
  end, {})
end

return M
