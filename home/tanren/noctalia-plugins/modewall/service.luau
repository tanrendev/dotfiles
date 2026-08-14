noctalia.setUpdateInterval(1000)

local assignments = {}
local lastDark = nil
local pendingGreeterSync = false
local warnedMissing = {}

local function stateFile()
  local dir = noctalia.pluginDataDir()
  if type(dir) ~= "string" or dir == "" then
    return nil
  end
  return dir .. "/assignments.json"
end

local function persist()
  local file = stateFile()
  if file == nil then
    return
  end
  local encoded = noctalia.json.encode({
    light = assignments.light,
    dark = assignments.dark,
  })
  if encoded ~= nil then
    local ok, err = noctalia.writeFile(file, encoded)
    if not ok then
      noctalia.log("modewall: failed to persist assignments: " .. tostring(err))
    end
  end
end

local function restore()
  local file = stateFile()
  if file == nil then
    return
  end
  local content = noctalia.readFile(file)
  if type(content) ~= "string" or content == "" then
    return
  end
  local decoded = noctalia.json.decode(content)
  if type(decoded) ~= "table" then
    return
  end
  if type(decoded.light) == "string" and decoded.light ~= "" then
    assignments.light = decoded.light
  end
  if type(decoded.dark) == "string" and decoded.dark ~= "" then
    assignments.dark = decoded.dark
  end
end

local function publish()
  noctalia.state.set("assignments", {
    light = assignments.light,
    dark = assignments.dark,
  })
end

local function currentMode()
  return noctalia.isDarkMode() and "dark" or "light"
end

local function apply(mode)
  local path = assignments[mode]
  if type(path) ~= "string" or path == "" then
    return
  end
  if not noctalia.fileExists(path) then
    if not warnedMissing[path] then
      warnedMissing[path] = true
      noctalia.notify(noctalia.tr("notify.title"), noctalia.tr("notify.missing", { path = path }))
    end
    return
  end
  warnedMissing[path] = nil
  noctalia.setWallpaper(path)
  if noctalia.getConfig("greeter_sync") then
    pendingGreeterSync = true
  end
end

function update()
  if pendingGreeterSync then
    pendingGreeterSync = false
    noctalia.runAsync("noctalia msg greeter-sync", function(result)
      if result.exitCode ~= 0 then
        noctalia.log("modewall: greeter-sync failed: " .. noctalia.string.trim(result.stderr))
      end
    end)
  end
  local dark = noctalia.isDarkMode()
  if lastDark == nil then
    lastDark = dark
    if noctalia.getConfig("apply_on_startup") then
      apply(currentMode())
    end
    return
  end
  if dark ~= lastDark then
    lastDark = dark
    apply(currentMode())
  end
end

noctalia.state.watch("command", function(cmd)
  if type(cmd) ~= "table" then
    return
  end
  if cmd.mode ~= "light" and cmd.mode ~= "dark" then
    return
  end
  if cmd.action == "set" and type(cmd.path) == "string" and cmd.path ~= "" then
    assignments[cmd.mode] = cmd.path
    persist()
    publish()
    if cmd.mode == currentMode() then
      apply(cmd.mode)
    end
  elseif cmd.action == "clear" then
    assignments[cmd.mode] = nil
    persist()
    publish()
  end
end)

restore()
publish()
