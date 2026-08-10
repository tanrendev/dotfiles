local step = 0
local last = ""
local queue = {}
local events = {}

pcall(function()
  math.randomseed(os.time())
end)

local function plan()
  events = {}
  events[math.random(4, 28)] = { "blink1", "blink2", "blink1" }
  events[math.random(34, 60)] = { "hop1", "hop2", "hop2", "hop1" }
end

local function show(frame, interval)
  noctalia.setUpdateInterval(interval)
  local mode = noctalia.isDarkMode() and "dark" or "light"
  local key = frame .. mode
  if key ~= last then
    last = key
    barWidget.render(ui.image({ path = "sprites/owl-" .. frame .. "-" .. mode .. ".png", width = 32, height = 32 }))
  end
end

function update()
  if #queue > 0 then
    show(table.remove(queue, 1), 100)
    return
  end
  if step == 0 then
    plan()
  end
  step = (step + 1) % 64
  local ev = events[step]
  if ev then
    queue = { table.unpack(ev) }
    show(table.remove(queue, 1), 100)
    return
  end
  show("open", 250)
end
