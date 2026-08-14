local PANEL_WIDTH = 920
local PANEL_PADDING = 28
local COLUMNS = 4
local COLUMN_GAP = 12
local PAGE_SIZE = 12
local TILE_RADIUS = 12
local IMAGE_EXTENSIONS = { png = true, jpg = true, jpeg = true, webp = true }

local wallpapers = {}
local page = 1
local errorMessage = ""
local cmdNonce = 0

local render

local function tr(key)
  return noctalia.tr(key)
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
  return ui.column({ gap = 4, key = wallpaper.path, flexGrow = 1, align = "stretch" }, {
    ui.image({
      width = frameWidth,
      height = frameHeight,
      path = wallpaper.path,
      fit = "cover",
      radius = TILE_RADIUS,
      border = marked and "primary" or "outline",
      borderWidth = marked and 3 or 1,
    }),
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
