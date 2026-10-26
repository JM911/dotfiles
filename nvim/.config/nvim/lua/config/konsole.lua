-- Match Konsole's session background to the theme's Normal color so that
-- the profile's GUI transparency setting also applies inside Neovim.
local M = {}

function M.setup()
  local applied = false
  local active = false
  local original_bg
  local query_id = 0
  local pending = false
  local function send(sequence)
    io.stdout:write(sequence)
    io.stdout:flush()
  end

  local function apply()
    if not active then
      return
    end
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
    -- Do not change the terminal until we know how to restore it. OSC 111
    -- is not supported by Konsole (and older Windows Terminal versions).
    if not original_bg then
      if not pending then
        pending = true
        query_id = query_id + 1
        local id = query_id
        send("\27]11;?\27\\")
        vim.defer_fn(function()
          if query_id == id then
            pending = false
          end
        end, 1000)
      end
      return
    end
    send(string.format("\27]11;#%06x\27\\", bg))
    applied = true
  end

  local function restore()
    active = false
    pending = false
    query_id = query_id + 1
    if applied then
      send("\27]11;" .. original_bg .. "\27\\")
      applied = false
    end
  end

  local group = vim.api.nvim_create_augroup("KonsoleThemeBackground", { clear = true })
  vim.api.nvim_create_autocmd("TermResponse", {
    group = group,
    callback = function(ev)
      if not active or not pending then
        return
      end
      local sequence = ev.data and ev.data.sequence or vim.v.termresponse
      local r, g, b = sequence:match("^\27%]11;rgb:([%x]+)/([%x]+)/([%x]+)")
      if not r or #r > 4 or #g > 4 or #b > 4 then
        return
      end
      -- Konsole reports rgb:RRRR/GGGG/BBBB, but its QColor parser only
      -- accepts hex/name syntax when setting the background. Scale each
      -- component (which can contain 1-4 hex digits) to an 8-bit value.
      local function byte(component)
        local maximum = 16 ^ #component - 1
        return math.floor(tonumber(component, 16) * 255 / maximum + 0.5)
      end
      original_bg = string.format("#%02x%02x%02x", byte(r), byte(g), byte(b))
      pending = false
      apply()
    end,
  })
  vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
    group = group,
    callback = function()
      active = true
      apply()
    end,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = apply,
  })
  vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
    group = group,
    callback = restore,
  })
end

return M
