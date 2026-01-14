local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- モジュール読み込み
require("on")
local tab_bar = require("tab_bar")

-- カラースキーム
config.color_scheme = "Iceberg Dark"

-- フォント
config.font = wezterm.font("MonaspiceAr Nerd Font Mono")
config.line_height = 1.1
config.treat_east_asian_ambiguous_width_as_wide = true

-- カーソル
config.default_cursor_style = "BlinkingBlock"

-- ウィンドウ
config.window_close_confirmation = "NeverPrompt"
config.initial_rows = 50
config.initial_cols = 150

-- 透明度とブラー（macOS）
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20

-- ウィンドウパディング
config.window_padding = {
  left = 4,
  right = 4,
  top = 4,
  bottom = 4,
}

-- キーバインド（透明度・ブラートグル用）
config.keys = {
  {
    key = "o",
    mods = "CMD|SHIFT",
    action = wezterm.action.EmitEvent("toggle-opacity"),
  },
  {
    key = "b",
    mods = "CMD|SHIFT",
    action = wezterm.action.EmitEvent("toggle-blur"),
  },
}

-- タブバー設定をマージ
for k, v in pairs(tab_bar) do
  config[k] = v
end

return config
