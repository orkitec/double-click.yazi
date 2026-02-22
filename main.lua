--- Double-click to open files and enter directories in Yazi.
--- https://github.com/orkitec/double-click.yazi
--- @sync entry

local M = {}

local click_state = { phase = 0, last_up_time = 0, url = nil }
local threshold = 0.3

function M:setup(opts)
  opts = opts or {}
  threshold = opts.threshold or 0.3

  function Entity:click(event, up)
    if event.is_middle then
      return
    end

    local url = tostring(self._file.url)
    local now = ya.time()

    if not up then
      -- Mouse down: select the file
      ya.emit("reveal", { self._file.url })

      -- Right-click: show interactive open menu
      if event.is_right then
        ya.emit("open", { interactive = true })
        return
      end

      if click_state.phase == 1 and url == click_state.url and (now - click_state.last_up_time) < threshold then
        click_state.phase = 2
      else
        click_state.phase = 0
        click_state.url = url
      end
      return
    end

    -- Mouse up (left only)
    if event.is_right then
      return
    end

    if click_state.phase == 0 and url == click_state.url then
      click_state.phase = 1
      click_state.last_up_time = now
    elseif click_state.phase == 2 and url == click_state.url then
      if self._file.cha.is_dir then
        ya.emit("enter", {})
      else
        ya.emit("open", {})
      end
      click_state.phase = 0
      click_state.url = nil
      click_state.last_up_time = 0
    else
      click_state.phase = 0
      click_state.url = nil
    end
  end
end

return M
