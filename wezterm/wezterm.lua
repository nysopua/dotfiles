local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- モジュール読み込み
require("on")
local tab_bar = require("tab_bar")

-- カラースキーム
config.color_scheme = "iceberg-dark"

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

-- LEADER キー（CTRL+A、1秒以内に次のキーを押す）
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- キーバインド
config.keys = {
  -- LEADER 系
  { key = "a", mods = "LEADER|CTRL", action = act.SendString("\x01") }, -- CTRL+A を送信
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "Space", mods = "LEADER", action = act.QuickSelect },
  { key = ";", mods = "LEADER", action = act.ToggleFullScreen },

  -- ペイン操作
  { key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "z", mods = "CMD", action = act.TogglePaneZoomState },
  { key = "LeftArrow", mods = "CMD|ALT", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "CMD|ALT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "CMD|ALT", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = "CMD|ALT", action = act.ActivatePaneDirection("Down") },

  -- タブ操作
  { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "W", mods = "CMD|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },

  -- ワークスペース
  { key = "n", mods = "CMD|SHIFT", action = act.SwitchWorkspaceRelative(1) },
  { key = "p", mods = "CMD|SHIFT", action = act.SwitchWorkspaceRelative(-1) },

  -- カスタム
  { key = "o", mods = "CMD|SHIFT", action = act.EmitEvent("toggle-opacity") },
  { key = "b", mods = "CMD|SHIFT", action = act.EmitEvent("toggle-blur") },
  { key = "r", mods = "CMD|SHIFT", action = act.ReloadConfiguration },
  {
    key = "h",
    mods = "CMD|SHIFT",
    action = act.SpawnCommandInNewTab({
      args = { "/bin/zsh", "-lc", "bat --style=plain ~/dotfiles/wezterm/cheatsheet.md; read" },
    }),
  },
}

-- LEADER+1-9 でタブ選択
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
end

-- タブバー設定をマージ
for k, v in pairs(tab_bar) do
  config[k] = v
end

return config
