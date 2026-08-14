local function render()
  barWidget.setGlyph(noctalia.isDarkMode() and "moon" or "sun")
  barWidget.setTooltip(noctalia.tr("title"))
end

function update()
  render()
end

function onClick()
  noctalia.togglePanel("tanren/modewall:picker")
end

render()
