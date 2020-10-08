# wl-clipboard
# https://github.com/bugaevc/wl-clipboard
#
# Clipboard integration for Wayland.

provide-module wl-clipboard %{
  # Copy
  hook global RegisterModified '"' %{
    nop %sh{
      wl-copy -- "$kak_main_reg_dquote" > /dev/null 2>&1
    }
  }

  # Paste
  map -docstring 'Paste after' global user p '<a-!>wl-paste --no-newline<ret>'
  map -docstring 'Paste before' global user P '!wl-paste --no-newline<ret>'
  map -docstring 'Replace' global user R '|wl-paste --no-newline<ret>'
}
