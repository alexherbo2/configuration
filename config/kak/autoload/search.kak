# Configuration:
#
# map -docstring 'Search' global user f ':search<ret>(?i)\Q'
#
# Search highlighter:
#
# set-face global Search black,yellow+uf
#
# hook global RegisterModified '/' %{
#   add-highlighter -override global/search regex "%reg{/}" 0:Search
# }
#
# Show line numbers with the cursor line:
#
# add-highlighter global/number-lines number-lines -hlcursor

define-command -override search -docstring 'Search' %{
  set-register X %reg{/}
  prompt search: '' -on-change 'set-register / %val{text}' -on-abort 'set-register / %reg{X}'
}

map -docstring 'Search' global user f ':search<ret>(?i)\Q'
