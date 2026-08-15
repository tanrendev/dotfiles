noctalia.setUpdateInterval(1000)

local lastDark = noctalia.isDarkMode()

function update()
  local dark = noctalia.isDarkMode()
  if dark == lastDark then
    return
  end
  lastDark = dark
  local path = noctalia.getConfig(dark and "dark" or "light")
  if type(path) == "string" and path ~= "" then
    noctalia.setWallpaper(path)
  end
end
