local wezterm = require("wezterm")

-- 透明度トグル（CMD+SHIFT+O）
wezterm.on("toggle-opacity", function(window, _)
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity == 1.0 then
    overrides.window_background_opacity = 0.85
  else
    overrides.window_background_opacity = 1.0
  end
  window:set_config_overrides(overrides)
end)

-- ブラートグル（CMD+SHIFT+B）- macOS のみ
wezterm.on("toggle-blur", function(window, _)
  local overrides = window:get_config_overrides() or {}
  if overrides.macos_window_background_blur == 0 then
    overrides.macos_window_background_blur = 20
  else
    overrides.macos_window_background_blur = 0
  end
  window:set_config_overrides(overrides)
end)

-- 起動時にウィンドウを最大化
wezterm.on("gui-startup", function(_)
  local _, _, window = wezterm.mux.spawn_window({})
  window:gui_window():maximize()
end)
