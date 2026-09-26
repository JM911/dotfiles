-- Match Konsole's session background to the theme's Normal color so that
-- the profile's GUI transparency setting also applies inside Neovim.
local M = {}

function M.setup()
  local applied = false
  local function send(sequence)
    io.stdout:write(sequence)
    io.stdout:flush()
  end

  local function apply()
    -- Do not emit terminal escape sequences in headless/embedded sessions.
    local terminal_ui = false
    for _, ui in ipairs(vim.api.nvim_list_uis()) do
      if ui.stdout_tty then
        terminal_ui = true
        break
      end
    end
    if not terminal_ui then
      return
    end

    local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
    if not bg then
      return
    end
    send(string.format("\27]11;#%06x\27\\", bg))
    applied = true
  end

  local function restore()
    if applied then
      -- OSC 111 restores the background from Konsole's color scheme.
      send("\27]111\27\\")
      applied = false
    end
  end

  local group = vim.api.nvim_create_augroup("KonsoleThemeBackground", { clear = true })
  vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "ColorScheme" }, {
    group = group,
    callback = apply,
  })
  vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
    group = group,
    callback = restore,
  })
end

return M
