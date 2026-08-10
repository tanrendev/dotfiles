local last = ""

noctalia.setUpdateInterval(100)

function update()
  local mode = noctalia.isDarkMode() and "dark" or "light"
  if mode ~= last then
    last = mode
    noctalia.state.set("mode", mode)
  end
end
