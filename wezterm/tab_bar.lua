-- タブバー設定（Iceberg Dark テーマに合わせた配色）
return {
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  show_tab_index_in_tab_bar = false,
  tab_bar_at_bottom = false,

  colors = {
    tab_bar = {
      background = "#161821",

      active_tab = {
        bg_color = "#444b71",
        fg_color = "#c6c8d1",
        intensity = "Normal",
      },

      inactive_tab = {
        bg_color = "#1e2132",
        fg_color = "#6b7089",
      },

      inactive_tab_hover = {
        bg_color = "#282d3e",
        fg_color = "#c6c8d1",
        italic = true,
      },

      new_tab = {
        bg_color = "#161821",
        fg_color = "#6b7089",
      },

      new_tab_hover = {
        bg_color = "#282d3e",
        fg_color = "#c6c8d1",
      },
    },
  },
}
