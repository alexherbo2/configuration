-- WezTerm
-- https://wezfurlong.org/wezterm/

local wezterm = require 'wezterm'

return {
  -- Shell
  -- https://wezfurlong.org/wezterm/config/launch.html
  --
  -- Nushell
  -- https://nushell.sh
  default_prog = { 'nu' },

  -- Color scheme
  -- https://wezfurlong.org/wezterm/config/appearance.html
  --
  -- Dracula
  -- https://draculatheme.com
  color_scheme = 'Dracula',

  window_background_opacity = 0.8,

  -- Font configuration
  -- https://wezfurlong.org/wezterm/config/fonts.html
  font = wezterm.font('PragmataPro'),
  font_size = 11.0,

  -- Disable ligatures
  -- https://wezfurlong.org/wezterm/config/font-shaping.html
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },

  -- Enable CSI u mode
  -- https://wezfurlong.org/wezterm/changelog.html?highlight=enable_csi_u_key_encoding#20200620-160318-e00b076c
  enable_csi_u_key_encoding = true
}
