local wezterm = require 'wezterm'

return {
  default_prog = { 'elvish' },
  color_scheme = 'Dracula',
  font = wezterm.font('PragmataPro'),
  font_size = 11.0,
  -- Disable ligatures
  -- https://wezfurlong.org/wezterm/config/font-shaping.html
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  enable_csi_u_key_encoding = true,
  enable_wayland = true
}
