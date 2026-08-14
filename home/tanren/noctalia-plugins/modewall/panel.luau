local PANEL_WIDTH = 920
local PANEL_PADDING = 28
local COLUMNS = 4
local COLUMN_GAP = 12
local PAGE_SIZE = 12
local TILE_RADIUS = 12
local THUMB_MAX_CONCURRENT = 4
local THUMB_WIDTH = 640
local IMAGE_EXTENSIONS = { png = true, jpg = true, jpeg = true, webp = true }
local CACHE_DIR = (noctalia.getenv("XDG_CACHE_HOME") or ((noctalia.getenv("HOME") or "") .. "/.cache"))
  .. "/noctalia/modewall"

local wallpapers = {}
local page = 1
local errorMessage = ""
local cmdNonce = 0
local ffmpegAvailable = noctalia.commandExists("ffmpeg")

local thumbPaths = {}
local thumbPending = {}
local thumbQueue = {}
local thumbActive = 0

local render

local function tr(key)
  return noctalia.tr(key)
end

local function shellQuote(s)
  return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

local function assignments()
  local published = noctalia.state.get("assignments")
  if type(published) == "table" then
    return published
  end
  return {}
end

local function extensionOf(name)
  local ext = name:match("%.([%a%d]+)$")
  return ext and ext:lower() or ""
end

local function cachePath(path)
  return CACHE_DIR .. "/" .. path:gsub("[^%w]", "_") .. ".jpg"
end

local function pumpThumbQueue()
  while thumbActive < THUMB_MAX_CONCURRENT and #thumbQueue > 0 do
    local path = table.remove(thumbQueue, 1)
    if thumbPaths[path] == nil and not thumbPending[path] then
      thumbPending[path] = true
      thumbActive += 1
      local dest = cachePath(path)
      local cmd = "ffmpeg -y -loglevel error -i " .. shellQuote(path)
        .. " -vf scale=" .. THUMB_WIDTH .. ":-2 -frames:v 1 " .. shellQuote(dest)
      noctalia.runAsync(cmd, function(result)
        thumbActive -= 1
        thumbPending[path] = nil
        if result.exitCode == 0 and noctalia.fileExists(dest) then
          thumbPaths[path] = dest
          render()
        end
        pumpThumbQueue()
      end, 20000)
    end
  end
end

local function queueThumb(path)
  if not ffmpegAvailable then
    thumbPaths[path] = path
    return
  end
  if noctalia.fileExists(cachePath(path)) then
    thumbPaths[path] = cachePath(path)
    return
  end
  if thumbPending[path] then
    return
  end
  table.insert(thumbQueue, path)
  pumpThumbQueue()
end

local function loadWallpapers()
  wallpapers = {}
  errorMessage = ""
  local dir = noctalia.wallpaperDirectory()
  if type(dir) ~= "string" or dir == "" then
    errorMessage = tr("no_directory")
    return
  end
  dir = noctalia.expandPath(dir)
  local entries = noctalia.listDir(dir)
  if type(entries) ~= "table" then
    errorMessage = tr("empty")
    return
  end
  for _, name in ipairs(entries) do
    if name:sub(1, 1) ~= "." and IMAGE_EXTENSIONS[extensionOf(name)] then
      local path = dir .. "/" .. name
      local info = noctalia.fileInfo(path)
      if info ~= nil and not info.isDir then
        table.insert(wallpapers, { path = path, name = name })
      end
    end
  end
  table.sort(wallpapers, function(a, b)
    return a.name < b.name
  end)
  page = 1
  noctalia.runAsync("mkdir -p " .. shellQuote(CACHE_DIR), function(_)
    for _, wallpaper in ipairs(wallpapers) do
      queueThumb(wallpaper.path)
    end
  end)
end

local function sendCommand(action, mode, path)
  cmdNonce += 1
  noctalia.state.set("command", { action = action, mode = mode, path = path, nonce = cmdNonce })
end

local function totalPages()
  return math.max(1, math.ceil(#wallpapers / PAGE_SIZE))
end

local function tileSize()
  local width = math.floor(((PANEL_WIDTH - PANEL_PADDING) - COLUMN_GAP * (COLUMNS - 1)) / COLUMNS)
  return width, math.floor(width * 9 / 16)
end

local function modeButton(mode, path)
  local active = assignments()[mode] == path
  return ui.button({
    glyph = mode == "light" and "sun" or "moon",
    text = tr(mode),
    variant = active and "primary" or "outline",
    flexGrow = 1,
    onClick = function()
      if active then
        sendCommand("clear", mode, nil)
      else
        sendCommand("set", mode, path)
      end
      render()
    end,
  })
end

local function wallpaperTile(wallpaper)
  local frameWidth, frameHeight = tileSize()
  local assigned = assignments()
  local marked = assigned.light == wallpaper.path or assigned.dark == wallpaper.path
  local thumb = thumbPaths[wallpaper.path]
  local preview
  if thumb ~= nil then
    preview = ui.image({
      width = frameWidth,
      height = frameHeight,
      path = thumb,
      fit = "cover",
      radius = TILE_RADIUS,
      border = marked and "primary" or "outline",
      borderWidth = marked and 3 or 1,
    })
  else
    preview = ui.box({
      width = frameWidth,
      height = frameHeight,
      fill = "surface_variant",
      radius = TILE_RADIUS,
      border = marked and "primary" or "outline",
      borderWidth = marked and 3 or 1,
    })
  end
  return ui.column({ gap = 4, key = wallpaper.path, flexGrow = 1, align = "stretch" }, {
    preview,
    ui.label({
      text = wallpaper.name,
      fontSize = 11,
      color = marked and "primary" or "on_surface_variant",
      maxLines = 1,
      maxWidth = frameWidth,
      textAlign = "center",
    }),
    ui.row({ gap = 4, align = "stretch" }, {
      modeButton("light", wallpaper.path),
      modeButton("dark", wallpaper.path),
    }),
  })
end

local function wallpaperGrid()
  if #wallpapers == 0 then
    return ui.label({ text = errorMessage ~= "" and errorMessage or tr("empty"), color = "on_surface_variant" })
  end
  local first = (page - 1) * PAGE_SIZE + 1
  local last = math.min(first + PAGE_SIZE - 1, #wallpapers)
  local rows = {}
  local row = {}
  for i = first, last do
    table.insert(row, wallpaperTile(wallpapers[i]))
    if #row == COLUMNS or i == last then
      while #row < COLUMNS do
        table.insert(row, ui.column({ flexGrow = 1 }))
      end
      table.insert(rows, ui.row({ gap = COLUMN_GAP, align = "stretch" }, row))
      row = {}
    end
  end
  return ui.column({ gap = 12, align = "stretch" }, rows)
end

render = function()
  panel.render(ui.column({ flexGrow = 1, gap = 12, align = "stretch" }, {
    ui.row({ align = "center", justify = "space_between", gap = 8 }, {
      ui.label({ text = tr("title"), fontSize = 16, fontWeight = "bold", color = "on_surface", flexGrow = 1 }),
      ui.button({ glyph = "close", onClick = "onClosePanel" }),
    }),
    ui.scroll({ flexGrow = 1, gap = 12 }, {
      wallpaperGrid(),
    }),
    ui.row({ align = "center", justify = "space_between", gap = 8 }, {
      ui.button({ glyph = "chevron-left", variant = "ghost", onClick = "onPrevPage", enabled = page > 1 }),
      ui.label({ text = `{page} / {totalPages()}`, color = "on_surface_variant" }),
      ui.button({ glyph = "chevron-right", variant = "ghost", onClick = "onNextPage", enabled = page < totalPages() }),
    }),
  }))
end

function onOpen(_context)
  loadWallpapers()
  render()
end

function onPrevPage()
  if page > 1 then
    page -= 1
    render()
  end
end

function onNextPage()
  if page < totalPages() then
    page += 1
    render()
  end
end

function onClosePanel()
  panel.close()
end

noctalia.state.watch("assignments", function(_)
  render()
end)
