--!nonstrict
-- Split Reset bar widget: a click sets every split on this bar's monitor
-- back to 50/50. The work happens in split_reset(), defined by
-- hyprland/split_reset.lua, loaded into Hyprland's own Lua config.

function update()
  barWidget.setGlyph("layout-columns")
  barWidget.setText("")
  barWidget.setGlyphColor("on_surface")
  barWidget.setTooltip(noctalia.tr("ui.tooltip"))
end

function onClick()
  -- each bar resets its own monitor, not the focused one
  local out = barWidget.outputName()
  local call = "split_reset()"
  if out ~= nil and out ~= "" then
    call = string.format("split_reset({ monitor = %q })", out)
  end
  local queued = noctalia.runAsync({ "hyprctl", "eval", call }, function(result)
    local text = type(result) == "table" and (result.stdout or "") or ""
    if text:find("error") then
      noctalia.notifyError(noctalia.tr("ui.title"), text)
    end
  end)
  if not queued then
    noctalia.notifyError(noctalia.tr("ui.title"), noctalia.tr("ui.not-run"))
  end
end
